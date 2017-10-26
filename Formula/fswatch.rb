class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.11.0/fswatch-1.11.0.tar.gz"
  sha256 "9ad5fc35f835d37445dd4bc87738c5824d98c1ed564d0491b0a6625073b6c128"

  bottle do
    cellar :any
    sha256 "6ebd15db05bb0a0b3722ec1f2a8819d6db117ac259a029aa6d667194a537e17e" => :high_sierra
    sha256 "420b804f6672ed03d1e9c83923d83ef8794c3fb52239bf3844a31534c8d6c59f" => :sierra
    sha256 "e26fd44a355bd21f7228765dee8fd71cb92ef529cadefde9446057d4183cddef" => :el_capitan
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
