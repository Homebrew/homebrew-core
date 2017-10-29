class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.11.2/fswatch-1.11.2.tar.gz"
  sha256 "b7dadb84848ce666aac0311f9b4c739fbfee6a90c6097807a1f45ad4367294c2"

  bottle do
    cellar :any
    sha256 "c0d8de2643b571f92c2c994791304b7ffdf87e6f8eebf5c73cff0ee67b059756" => :high_sierra
    sha256 "83efe7d745f996bf09ee221554de51431a9d5c4efac0cbec4091316acfaf5555" => :sierra
    sha256 "7e440663afc857fbb005d7d0797be8bc3f661db39e7a852c3f058e8b00e96c87" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
