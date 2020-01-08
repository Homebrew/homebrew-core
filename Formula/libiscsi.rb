class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/1.19.0.tar.gz"
  sha256 "c7848ac722c8361d5064654bc6e926c2be61ef11dd3875020a63931836d806df"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    cellar :any
    sha256 "e33ab94bb94c63eab8836acfe89a677120293eeaf745c29648a03844779a6b4c" => :catalina
    sha256 "473988c2ba81d9d9cf6eb21f2f3d41ade13e76131a2c2aabdade9983c79f99ed" => :mojave
    sha256 "c05b614ecbacf4f957777c33144924322147b40b898fbb1acf91b72663e35203" => :high_sierra
    sha256 "832760665cad678de3079365edc72bc21d946dd03ecff9304220b9972a29dd8c" => :sierra
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
