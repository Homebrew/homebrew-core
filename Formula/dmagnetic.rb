class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.30.tar.bz2"
  sha256 "9eb825290495150b8ae4eeb0ff04aba724c1fd8f6052b0c4cb90865787f922be"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "251ac8bda70a80074011d12eca43a73aa384c8f454de6094a9acb9496119cc01"
    sha256 cellar: :any_skip_relocation, big_sur:       "235726add0421eccea8b98029679e9ae0e483cdd8e3697c7f48f87422e43e974"
    sha256 cellar: :any_skip_relocation, catalina:      "eb2ad791a4ec9277506eb89c633c081c27ce76075dc387a7ada5233636a67621"
    sha256 cellar: :any_skip_relocation, mojave:        "d6c6f159b7dad10ae909df0f00984cf1887364fcfc667a74fa51f89d3aaec5f5"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "ab9ec7787593e310ac4d8187db3f6cee", \
      shell_output("echo Hello | #{bin}/dMagnetic "\
        "-vmode none -vcols 300 -vrows 300 -vecho -sres 1024x768 "\
        "-mag #{share}/games/dMagnetic/minitest.mag "\
        "-gfx #{share}/games/dMagnetic/minitest.gfx "\
        "| md5").strip
  end
end
