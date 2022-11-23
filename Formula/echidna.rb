class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "6bae214814c24ab536803ddd90072c5a102af5566e21ce954cc8e134bf518a94"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d92cda5e59881bad69cfcda38afff0197fd5eec2784d9f03a853e9f254b1210f"
    sha256 cellar: :any,                 arm64_big_sur:  "8ad1017887613571d487aca57d22b641195985f3e77fc058ec3ab2ee06796dcf"
    sha256 cellar: :any,                 monterey:       "89ab78d9c7ce7a25b70bd1c7abe9ebf3655f436043b569c853c64d85c82423bf"
    sha256 cellar: :any,                 big_sur:        "75d1d728a12a4d2ddc4cfca818d3cf419bba5dae1fc8b9acd9ecf5d853f919c9"
    sha256 cellar: :any,                 catalina:       "be1a4f7ed8e2f60994928f03cf8e4b5b892d9a32640f97278ba0bae585785ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b244ba9b210535d6e72cc716fcb1ae372ad349bff8646c9e01bfd4f207c2408"
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
