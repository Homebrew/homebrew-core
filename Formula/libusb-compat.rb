class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2"
  sha256 "404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a"
  revision 1

  bottle do
    cellar :any
    sha256 "11fe66aff70c0177a186c946624f91417565c43bbdc9e7c51725e26ea0c868c5" => :mojave
    sha256 "fccc08c6c3ff2bf93d2aa8e7cc18f30c1fb95fbca044ecaa42d45f7c73a8facf" => :high_sierra
    sha256 "e24ad80ee860f6f6c7e6c8dbb100aaa2de3294e2ecf7f591f2f51c52e11f09ea" => :sierra
    sha256 "7b62449f8a9c02834b74adeb0827ca2ae32b47cb82923de0a8e88f16c36ca8b8" => :el_capitan
    sha256 "0e4f131b8fd8210db3ff353a92c35ed12643a717b8780618680e3b4a16d7f347" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/libusb-config", "--libs"
  end
end
