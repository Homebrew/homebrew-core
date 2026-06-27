class MdTui < Formula
  desc "Markdown renderer in the terminal written in rust"
  homepage "https://github.com/henriklovhaug/md-tui"
  url "https://github.com/henriklovhaug/md-tui/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "b62a6fab02bb00dce764bc4453b1248e2cbe3edd71ad28b45cb054bd896b1bfb"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f4b3c7e9eea808e761b210083c19cd6ae9a539ca01e26db4ab06a0749316725"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a874755b5175984116d156c4225075e39ca4bc95858ef9e8e8060c99ff802914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d1f9a8387bd44408a328f945a781ff9dc45cfcd425e1a37c6bbc8d2c2324d50"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac1594a158708f890021396de466714bc60bdac125087016fa10e5511e33f49"
    sha256 cellar: :any,                 arm64_linux:   "da8145094edd14c9879a1653b569a1da74bd5068957a34ec96ef1105d480f8f1"
    sha256 cellar: :any,                 x86_64_linux:  "82ada74130c0c18c1ec4062ee1590eb91cbb7e0e5d0b76058fd9191755e3aae8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"test.md").write "# Hello World"
    PTY.spawn(bin/"mdt", testpath/"test.md") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match "Hello World", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
