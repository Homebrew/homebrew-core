class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.9.3/fswatch-1.9.3.tar.gz"
  sha256 "b92043fb6bde122da79025e99dda110930c5688848dc5d401e3e3bf346012a65"

  bottle do
    cellar :any
    sha256 "1302fd01516f7484a9142bd4bd9bffa2beecec9471dece89ed67a76a123ddecf" => :el_capitan
    sha256 "16f086c38f0aae2898e99efb04234c6a075e0a0fdd4418a857b8e22d9b1a9136" => :yosemite
    sha256 "5bd59c4f6700cdbc00b43ed847c1f0f5bad6df04bd4361dfa5e0472682024ae3" => :mavericks
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
