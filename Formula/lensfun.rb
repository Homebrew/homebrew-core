class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "http://lensfun.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz"
  sha256 "ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331"
  head "http://git.code.sf.net/p/lensfun/code.git"

  bottle do
    sha256 "0a843c2663d8f6bca2f524fc6b8e3933587126481b4549667ae2cd9f3e96da00" => :sierra
    sha256 "4f75d6f3a79a1af741caf67401edf7436b7c1ad0d100ac1978043f9fadd14b96" => :el_capitan
    sha256 "2f86f02f6ffa890f23da494f4ea84fad99809793b472260e968846b3f1599ef1" => :yosemite
    sha256 "16bafe93312a00428a38e2488c825363152d7b11706596031649164780a41017" => :mavericks
  end

  depends_on :python3
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "doxygen" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
