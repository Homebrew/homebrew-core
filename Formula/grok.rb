class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage "https://github.com/jordansissel/grok"
  url "https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  head "https://github.com/jordansissel/grok.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "39e4a16aacd8785350973962a852781c27c585b9b317fb80333ee35633aab5c1" => :sierra
    sha256 "3a3894913d45c1989bb208d01e5a1d4c6a9f8fb7dbe8d354be2946b42553f9ff" => :el_capitan
    sha256 "550c236ce16a5ac0931a66538571686064f8e9c461a5ae7d2351e0d7d0ac7bb6" => :yosemite
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
