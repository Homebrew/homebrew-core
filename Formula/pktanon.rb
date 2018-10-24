class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 2

  bottle do
    cellar :any
    sha256 "693a899ccb1b6eba26f9b22facabb5034b6c08036e1f7935bd9143937b01d40b" => :mojave
    sha256 "74c7283cd64710b5afeaf545ccefc2ce291bea7cc6ad1dba565aaa676b76a3f0" => :high_sierra
    sha256 "150d2153a24d03d7f46aa8b82587c055c0ac9605b83efc5e44f90216c2888b48" => :sierra
    sha256 "2699dcad19aa003e10fc32651e1a0a6f93f38812393221a762793e27eafa2c5f" => :el_capitan
  end

  depends_on "boost"
  depends_on "xerces-c"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
      %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pktanon", "--version"
  end
end
