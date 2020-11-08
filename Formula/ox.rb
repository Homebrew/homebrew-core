class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/0.2.6.tar.gz"
  sha256 "5a0a395532cfffd90e51abb70ab214e7cbfe037a024c403abd2bdd803fd5394b"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7677242429502708970da5a5a4665cfa0b999581e6ab793ce8c4304d2488c6d7" => :catalina
    sha256 "fc76d843172825e04a7912b0aeace96c7e913c2b851f08cb646b4bc3f1add3aa" => :mojave
    sha256 "3008a1719ef3675fc9fb9c12de08dc7e1193877084f6a83db6a1ec87ac453da7" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    _, w, pid = PTY.spawn(bin/"ox", "test.txt")
    sleep 1
    w.write "Hello Homebrew!\n"
    w.write "\cS"
    sleep 1
    w.write "\cQ"

    assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
  ensure
    Process.kill("TERM", pid)
  end
end
