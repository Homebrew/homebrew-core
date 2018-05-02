class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.8.tar.gz"
  sha256 "65c364a9797178e40ec7ec653b2cfa8e211e556b75250bf72eb5eea57f5e0cdc"

  bottle do
    cellar :any
    sha256 "ff5d1ec8531b1e5994b6b822e94c9c92bfaed8d7918257e08b37c76aa4920d51" => :high_sierra
    sha256 "8be6a30a848f30382065ffdfcf0aaf17f59ce5239bba5b263f19e69ff3ea3a2d" => :sierra
    sha256 "c4884ba21bdcc444dfb2ef3df4ddd8f7f56194c159fec96fcef038092564c794" => :el_capitan
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
