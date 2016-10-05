class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "http://gva.noekeon.org/blahtexml/"
  url "http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz"
  sha256 "c5145b02bdf03cd95b7b136de63286819e696639824961d7408bec4591bc3737"

  bottle do
    cellar :any
    sha256 "be03733973aab454e1dc7cb52598d616778224c8e06e2a015ac1fb58ef8a8808" => :sierra
    sha256 "472b13bf5f305d0bdb3d822a81a21feee97315dbf90a27ed33853b237defd359" => :el_capitan
    sha256 "35e3afbd8968550c0f9446b2537163187fe0e7f79574bb88de097972506f42f1" => :yosemite
    sha256 "567c1b3872dc4d5e3b69b7c490ec4e5cd56669cf6d848cf6b451ae48a64f1661" => :mavericks
  end

  deprecated_option "blahtex-only" => "without-blahtexml"
  option "without-blahtexml", "Build only blahtex, not blahtexml"

  depends_on "xerces-c" if build.with? "blahtexml"

  # Add missing unistd.h includes, taken from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-mainPng.cpp.diff"
    sha256 "7d4bce5630881099b71beedbbc09b64c61849513b4ac00197b349aab2eba1687"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-main.cpp.diff"
    sha256 "d696d10931f2c2ded1cef50842b78887dba36679fbb2e0abc373e7b6405b8468"
  end

  def install
    system "make", "blahtex-mac"
    bin.install "blahtex"
    if build.with? "blahtexml"
      system "make", "blahtexml-mac"
      bin.install "blahtexml"
    end
  end
end
