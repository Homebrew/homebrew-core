class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "6bae214814c24ab536803ddd90072c5a102af5566e21ce954cc8e134bf518a94"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fbba243e373034caa449125e764dada8e86f83c3cf33fa2349c51a76550f90db"
    sha256 cellar: :any,                 arm64_big_sur:  "f9c643103e2d3f148340bfea740d5e51199142e3bd893ddd1dea8c8c2dccc8a6"
    sha256 cellar: :any,                 monterey:       "f0db6c31ad1fea50f906079f8fe7cb528256436653f84954cf3f6e60735acf85"
    sha256 cellar: :any,                 big_sur:        "c4f75d7be997bd45fa20dd926feec2b7d9808a3353ab377e87cc884fb68025d7"
    sha256 cellar: :any,                 catalina:       "b094e223745a31304dd729e7259b82af0dd47583439080f15307952117ac779b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83a538ed7a694f95992cbd16ce8d70a0d55788dd593c0b984857443acd2e65d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "libtool" => :build

  depends_on "crytic-compile"
  depends_on "libff"
  depends_on "slither-analyzer"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "secp256k1" do
    # this is the revision used to build upstream, see echidna/.github/scripts/install-libsecp256k1.sh
    url "https://github.com/bitcoin-core/secp256k1/archive/1086fda4c1975d0cad8d3cad96794a64ec12dca4.tar.gz"
    sha256 "ce97b9ff2c7add56ce9d165f05d24517faf73d17bd68a12459a32f84310af04f"
  end

  def install
    ENV.cxx11

    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", *std_configure_args,
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--libdir=#{libexec}/lib",
                            "--enable-module-recovery",
                            "--with-bignum=no",
                            "--with-pic"
      system "make", "install"
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{libexec}/include",
      "--extra-lib-dirs=#{libexec}/lib",
      "--ghc-options=-optl-Wl,-rpath,#{libexec}/lib",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "solc-select", "install", "0.7.0"

    (testpath/"test.sol").write <<~EOS
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    EOS

    with_env(SOLC_VERSION: "0.7.0") do
      assert_match(/echidna_true:(\s+)passed!/,
                   shell_output("#{bin}/echidna-test --format text #{testpath}/test.sol"))
    end
  end
end
