class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage "https://github.com/jordansissel/grok"
  url "https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  head "https://github.com/jordansissel/grok.git"

  bottle do
    cellar :any
    sha256 "e78484b8a0633f90615103a6fe0a1f9e3f4b6c05531c5dab29ecab9cea05c0a7" => :el_capitan
    sha256 "9b8d26342e9e9f7f172e32b25e97afbef5b360e541fbc4beacc6999f23b568f7" => :yosemite
    sha256 "39852bfe279fdffd8ea8fa6b6f1377c3693de4c2e74e84fbd94f08db8e16bb33" => :mavericks
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
