class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/v1.2.0.tar.gz"
  sha256 "2379d2d5c3e301140d9c65c4dcc2b99602acf511b2798f45009af4c1101a0716"
  license "MIT"
  head "https://github.com/orf/gping.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a89239b8418fbed36c48615ef509ef0f3cd11e600d68c623ff6094f95694e4ac" => :big_sur
    sha256 "12ad9db825834264cf54abe9f94a5c9da4bec17f9ff46fb4d1cfe7546027fdb1" => :catalina
    sha256 "9a2792ff20f09bbdbd0505498eb1d331bd333757e72c0374f7ac62556efbcc85" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub! /\e\[([;\d]+)?m/, ""

    assert_match "google.com (", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
