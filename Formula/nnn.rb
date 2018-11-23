class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.1.tar.gz"
  sha256 "bbfbd217a0c18741596d0cc5585c4160cf1848be4c6cb19c86b8a5249e3f2d2e"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1ae5c6f48f974ccfef60fe93fed0fff4936265829af53d5be73066264e47e34" => :mojave
    sha256 "e5c8b7b318a275246e9d474f8d7f00a5872723b7553794a4378c34956fa0fdfb" => :high_sierra
    sha256 "c4015691bb15f3a8de565d4ea5b4be48a0bed779d9b5ea40380d1898b90ba707" => :sierra
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
