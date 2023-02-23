class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "https://github.com/jonmacs/jove/archive/refs/tags/4.17.5.0.tar.gz"
  sha256 "bf7ad1d7e1625de25134d5341a50ad9fab3f1f49cc88ad1b79af2d9db7aa528c"

  bottle do
    sha256 arm64_ventura:  "dab2713caabaa568a7a8ad9b51928fe67a9cbd4af93fa36c9b15bbbb80ec47b7"
    sha256 arm64_monterey: "132a60a0db17f572b052d619330e51a26622a0cced239769eea9d6078269e1ae"
    sha256 arm64_big_sur:  "86c25c839c2840966fd336cc52cdbbef8d2cf83a96fc76ff79918d5368e21e4c"
    sha256 ventura:        "de72aa109f60feb1246cd96aa8eeba5959f27dded81a2c48f5a88cb32d09c585"
    sha256 monterey:       "62416384fee5373051cb7dd5522d7a8311a49127e6747c9331f8f95b6a4e89d6"
    sha256 big_sur:        "afb51b5da7ea5971652f148e429c71b825110c831a6e81f261e54bf191890c62"
    sha256 x86_64_linux:   "cb5e83e0c790c33068c0fa4b06277abed8fe7d5db2718420ff6a9b096479d9c3"
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
