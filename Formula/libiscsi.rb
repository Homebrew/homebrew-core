class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/1.19.0.tar.gz"
  sha256 "c7848ac722c8361d5064654bc6e926c2be61ef11dd3875020a63931836d806df"
  license "GPL-2.0"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f54d471025b9eda877c0b0d05c025f59b59413c1421c1335ff3091852e88e65"
    sha256 cellar: :any,                 arm64_big_sur:  "aa722adc6341c8457b38c0078ab264ae30982b57510967de3e8181088036e0e3"
    sha256 cellar: :any,                 monterey:       "76dcdbb37c5b4c48d997e904f6ab177258733cf4bae91e9fbf897e6208514d4a"
    sha256 cellar: :any,                 big_sur:        "ac06a7b7a74cf83e953f50e33455df97fc87880ebdac4f1dca89a62331375b1a"
    sha256 cellar: :any,                 catalina:       "e33ab94bb94c63eab8836acfe89a677120293eeaf745c29648a03844779a6b4c"
    sha256 cellar: :any,                 mojave:         "473988c2ba81d9d9cf6eb21f2f3d41ade13e76131a2c2aabdade9983c79f99ed"
    sha256 cellar: :any,                 high_sierra:    "c05b614ecbacf4f957777c33144924322147b40b898fbb1acf91b72663e35203"
    sha256 cellar: :any,                 sierra:         "832760665cad678de3079365edc72bc21d946dd03ecff9304220b9972a29dd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde67504bbf2d6f7097c9f48f817913c601b1d0bfc636409dac21904f7b79a19"
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
