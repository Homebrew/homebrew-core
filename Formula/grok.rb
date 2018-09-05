class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage "https://github.com/jordansissel/grok"
  url "https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  revision 1
  head "https://github.com/jordansissel/grok.git"

  bottle do
    cellar :any
    sha256 "0bce12fe9d96cc621b4ca8879ad8b4b2444de1ba86df62feb342dbed316f594d" => :mojave
    sha256 "88a6de27e9f3d8d53eb1d26ce202eaa08f66ea6587a41356ca62e205aef65345" => :high_sierra
    sha256 "18f3b7612397f4956e9013b37aecd55f47b0896edf3bdc7f4dc6833a8dcc54b0" => :sierra
    sha256 "0c494fb95ba85d3ab1dd9092165a22e0737c60c17035ce030efcb142990df0a0" => :el_capitan
    sha256 "f933ebf3d1fffbcc2512cdb32ef405d55ba6a9de1919eaf2f66e437e2dd34570" => :yosemite
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
