class Openhmd < Formula
  desc "Free and open source API and drivers for immersive technology"
  homepage "http://openhmd.net"
  url "https://github.com/OpenHMD/OpenHMD/archive/0.3.0.tar.gz"
  sha256 "ec5c97ab456046a8aef3cde6d59e474603af398f1d064a66e364fe3c0b26a0fa"
  head "https://github.com/OpenHMD/OpenHMD.git"

  bottle do
    cellar :any
    sha256 "351e8d9e6bfa22b63b035c0f9c0c7e37be52b9e4058c50d7b7ac321eca880e5b" => :catalina
    sha256 "796c1a6f06715aa8a3304cca0083378d5fe2a1006b55da8727938922b5408c8d" => :mojave
    sha256 "1c54727de5836916bca42065d0ed53f0a796d07ec6866408a69213c94b151092" => :high_sierra
    sha256 "97f5dff1e77b6b615544ed6611aa6d8c3395e3c6dc759c4576084d87a4e976ad" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "hidapi"

  conflicts_with "cspice", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"

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
