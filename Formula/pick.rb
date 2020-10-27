class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/mptre/pick"
  url "https://github.com/mptre/pick/releases/download/v4.0.0/pick-4.0.0.tar.gz"
  sha256 "de768fd566fd4c7f7b630144c8120b779a61a8cd35898f0db42ba8af5131edca"
  license "MIT"
  head "https://github.com/mptre/pick.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "754879e53b48743051bb1571bb4b6180a415ac36af8deaf335f5c193326d232f" => :catalina
    sha256 "55596e8ab28fd4fc36d064f6395c38ce51314bcc0d2f2f3862515a683bc92182" => :mojave
    sha256 "0fc521881c760d4f9e4f8625795716e0e1c0e1ed1522ccb5efd055313b2729bc" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    system "./configure"
    system "make", "install"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"pick") do |r, w, _pid|
      w.write "foo\nbar\nbaz\n\x04"
      sleep 1
      w.write "\n"
      assert_match /foo\r\nbar\r\nbaz\r\n\^D.*foo\r\n\z/, r.read
    end
  end
end
