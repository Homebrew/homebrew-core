class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.28.2",
      revision: "fa5864bb5838e131d832ad63300517f4684913e7"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a83e9b10fbf460f31a0df65c3b650a178138008d01ac9dd446e50f5e164f80c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09ecbab2c6d063f3faaf28ab7883d3986e76df47bc9a47f540503a7782dae42a"
    sha256 cellar: :any_skip_relocation, monterey:       "cbb8e63d14255f4f2f5b032f1a9c466289580c1faabdf5b7f5a66add4dfa0700"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b88db3933ab2b18877650e80ce1bce7daf540169299d09d9880926a6e8e71a8"
    sha256 cellar: :any_skip_relocation, catalina:       "29d1b566cea4427f9c80f3ba73bc004793ba0ac7baa1c947accac694124b1372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e5c6976da22a52679ab67a261bc74aecfe92b29d0903871c63a2b2177e61011"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build # required to compile .pb files
  depends_on "eigen"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "openblas"
  end

  fails_with gcc: "5"

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", using: :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  def install
    args = ["-Dgtest=false"]
    if OS.linux?
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end
    system "meson", *std_meson_args, *args, "build/release"

    cd "build/release" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec/"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end
