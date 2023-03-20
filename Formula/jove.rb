class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "https://github.com/jonmacs/jove/archive/refs/tags/4.17.5.2.tar.gz"
  sha256 "e28836e23001b79cd2d2e9e0174de426be46388e28b7086c57d3d072481af9b8"
  # license ref, https://github.com/jonmacs/jove/blob/4_17/LICENSE
  license :cannot_represent

  bottle do
    sha256 arm64_ventura:  "17fb3a433af9a259e60aad69c2cdcdad57b79fc3388df91ca34f1201d7a232c7"
    sha256 arm64_monterey: "bf899c09351194105327406a223797645d6a8cf7e6d601e76cc7ae8e262d1b06"
    sha256 arm64_big_sur:  "6a2ca46df6881b762f4f2c8162264a911bc094312dbca323dc46bd93abb864e0"
    sha256 ventura:        "1ae591eadac71b1594964fcead7644292e77589e49497865ba988598ec841335"
    sha256 monterey:       "8fb6fe7d2d05359a2d0252c1cab32c6a5aec339a761a8dbefbd941088e526537"
    sha256 big_sur:        "9885edd4fad084ad393d3d79fa299394f987150929af9b3b6ac92365464dd762"
    sha256 x86_64_linux:   "32b3cd9573308b5e7900c2bbe168a80d4a29ce93b81e25b80c0dbb8f767e68fc"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "DMANDIR=#{man1}"
  end

  test do
    assert_match "There's nothing to recover.", shell_output("#{lib}/jove/recover")
  end
end
