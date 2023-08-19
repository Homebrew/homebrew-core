class Openhmd < Formula
  desc "Free and open source API and drivers for immersive technology"
  homepage "http://openhmd.net"
  url "https://github.com/OpenHMD/OpenHMD/archive/0.3.0.tar.gz"
  sha256 "ec5c97ab456046a8aef3cde6d59e474603af398f1d064a66e364fe3c0b26a0fa"
  license "BSL-1.0"
  head "https://github.com/OpenHMD/OpenHMD.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b2e1d6170301fe50af6c5b9bee467a9c18f346cf2ff630338fd410bfbf992ff"
    sha256 cellar: :any,                 arm64_monterey: "536ae72b1f5e8dea9417cd010b787e4dfa94ece6c8fa3da651186f6e2ceb2d8c"
    sha256 cellar: :any,                 arm64_big_sur:  "19e9b946bbefe306dc41aa803e5cb48aec3ab62bf334b8975e660f4a3644c0c7"
    sha256 cellar: :any,                 ventura:        "3f960a5ab5e3466341ac6fcf533c317e37183338d770ca5b63f8aec92f48cd1b"
    sha256 cellar: :any,                 monterey:       "5e04fd446926530d2a5349d07d0354c4943c75b73220319ec38d27db42bb281e"
    sha256 cellar: :any,                 big_sur:        "875f651a4d9b710ce00e899928b2b9dab6f26cbfee670135566821e524d5337a"
    sha256 cellar: :any,                 catalina:       "351e8d9e6bfa22b63b035c0f9c0c7e37be52b9e4058c50d7b7ac321eca880e5b"
    sha256 cellar: :any,                 mojave:         "796c1a6f06715aa8a3304cca0083378d5fe2a1006b55da8727938922b5408c8d"
    sha256 cellar: :any,                 high_sierra:    "1c54727de5836916bca42065d0ed53f0a796d07ec6866408a69213c94b151092"
    sha256 cellar: :any,                 sierra:         "97f5dff1e77b6b615544ed6611aa6d8c3395e3c6dc759c4576084d87a4e976ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07dcb0b3e3848fe49493fef2323a7f143fb70a695e67738355f3c1f30008d44"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "hidapi"

  conflicts_with "cspice", because: "both install `simple` binaries"
  conflicts_with "libftdi0", because: "both install `simple` binaries"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"tests").install bin/"unittests"
  end

  test do
    system pkgshare/"tests/unittests"
  end
end
