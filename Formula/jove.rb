class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "https://github.com/jonmacs/jove/archive/refs/tags/4.17.5.1.tar.gz"
  sha256 "674fe3784c9aa58e1fbe010c7da8e026bffa5e057ab30341333a2dbcaf12887b"
  # license ref, https://github.com/jonmacs/jove/blob/4_17/LICENSE
  license :cannot_represent

  bottle do
    sha256 arm64_ventura:  "2e9b2657fad6c36e1e1b39b066ebf5ff7a1550e06282587fec73f12cbb88b64b"
    sha256 arm64_monterey: "9f9a6579f6d98004f457a666a5df11774a82bedab8272e97614497ecb97b8a85"
    sha256 arm64_big_sur:  "ba671e0e1eb0b24d2075c803bbfbeba555b68b63ca33d2f8dbbd2610fc245b5f"
    sha256 ventura:        "a3e1c2298a38918f69d2fb8a61a3a5874ca56bf3db8547af2f000c4aca0d4fca"
    sha256 monterey:       "3bee4c0523992eb074d6d794ef6aea2c49c1356107de08fd7ea3453c3fd0d215"
    sha256 big_sur:        "adf4187a1ea7ef17bf1855f6d1b26391bd64565f942adef7093a4635c8cf76f6"
    sha256 x86_64_linux:   "e5e285d1faece205fb8b5406b13f18d2925e9b91fab638645d80aed788317706"
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
