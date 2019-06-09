class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://packages.debian.org/sid/pinfo"
  url "https://github.com/baszoetekouw/pinfo/archive/v0.6.13.tar.gz"
  sha256 "9dc5e848a7a86cb665a885bc5f0fdf6d09ad60e814d75e78019ae3accb42c217"

  bottle do
    sha256 "e9b037201877468b88b7b86587977c5672f8ae4623faa0ed24db088b48618013" => :mojave
    sha256 "b8affb96e7d903da0fc32d873e19fad7a71a18bebb1ad514898eb2f05aa6a69d" => :high_sierra
    sha256 "e9e911c12b6fc6bcc46ec460848d4a927a3276b44d197790fbf491784008bfb1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pinfo", "-h"
  end
end
