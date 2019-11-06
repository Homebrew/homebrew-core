class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage "https://github.com/jordansissel/grok"
  url "https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  revision 2
  head "https://github.com/jordansissel/grok.git"

  bottle do
    cellar :any
    sha256 "8e3f44420143e731799d52290c9823a42a1833c4bc51906af59d4cd7c284f391" => :catalina
    sha256 "b78cf21dd67826d14d99188e631ff1c431913744d91089c4cefd9b3c9e9d9a46" => :mojave
    sha256 "41889afb55bfcf1d8b41eda76ef2272d29225f4cc4a5690bd409198417d7cf98" => :high_sierra
    sha256 "32dc46849684918dad9ca9005ca43b092de84b16a0837049146948379301b1fa" => :sierra
  end

  depends_on "libevent"
  depends_on "pcre"
  depends_on "tokyo-cabinet"

  def install
    # Race condition in generating grok_capture_xdr.h
    ENV.deparallelize
    system "make", "grok"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"grok", "-h"
  end
end
