class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/1.19.0.tar.gz"
  sha256 "c7848ac722c8361d5064654bc6e926c2be61ef11dd3875020a63931836d806df"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8fa9581efc6326e9b980813067cc40b46cd288109f50720260a58e1530604d69" => :mojave
    sha256 "b7d473398d94e269df98015f2187a791f61eaffcd1cc2dd4f043056e57d1820f" => :high_sierra
    sha256 "be04eca8be4587455ea7e5f7f696a0d473102093da3ef32c969ddc5f7e3263e7" => :sierra
    sha256 "7436d0d7cd21c2620f5144cc9137f8dcf8288a31310ec9e5fe951d868b2a889a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iscsi-ls", "--help"
    system bin/"iscsi-test-cu", "--list"
  end
end
