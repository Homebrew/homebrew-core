class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage "https://github.com/jordansissel/grok"
  url "https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/jordansissel/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d{6,8}(\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "2556c5995021bc02cf5a41c99bd30e127dedb7350972333c0bf77b695ed94114"
    sha256 cellar: :any, arm64_big_sur:  "172f626c4eb3d62d2f7b7dcd2c94a4890cc69a835ae3f33ddcb7b74762e4c52e"
    sha256 cellar: :any, monterey:       "111ecef9c1d93f0e737f47a7053ae84f5b434ae2bf808a49c7fbb9f9e4bb65e1"
    sha256 cellar: :any, big_sur:        "02386bec2f8e4ac68e44c67c33a2a296457a8f055fbf0f177a78137b63a030ce"
    sha256 cellar: :any, catalina:       "8e3f44420143e731799d52290c9823a42a1833c4bc51906af59d4cd7c284f391"
    sha256 cellar: :any, mojave:         "b78cf21dd67826d14d99188e631ff1c431913744d91089c4cefd9b3c9e9d9a46"
    sha256 cellar: :any, high_sierra:    "41889afb55bfcf1d8b41eda76ef2272d29225f4cc4a5690bd409198417d7cf98"
    sha256 cellar: :any, sierra:         "32dc46849684918dad9ca9005ca43b092de84b16a0837049146948379301b1fa"
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
