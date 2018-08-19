class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.12.0/fswatch-1.12.0.tar.gz"
  sha256 "8042da283b34dc383ff6321254163e378d4f3cd5d8df87ff608f811ea33e6a83"

  bottle do
    cellar :any
    sha256 "6a6e8c5fbf8bbd4611f86e7132a17a44708d4ccb61908c299a388a327b963fd2" => :mojave
    sha256 "8575f86b8f91844ed193cbd0b76a0f391e2e7e57bf3e00f37f800fb6a4847ed2" => :high_sierra
    sha256 "058f1aa3b1ce82e8fb35a5893e4d639992e5a2ffe0e10780e4ea165a5394f5a7" => :sierra
    sha256 "8338851b10412b958318c6582654ff092ca04af3dff83c5abaa14284c4b4f8de" => :el_capitan
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
