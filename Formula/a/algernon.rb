class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.6.tar.gz"
  sha256 "9e95d59c0d821e06b7193a115447bd16cd8bfa077538237a17bf508053ef15bb"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c75b3d100dbb2273af4f93598150e85c448a13a78162fead22afb984fe441d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dad0691fb5f8254bcd0a00d8efcd567f525474d7f484de065406ae21814f877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6908449baeedba72e01177442118460b6f56957b3bc8280db3172dce76b17582"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f9e842badd5076ca326a3c26a636c2cb13d88e5dc6b9707511cba62b45419e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "027ff4b400a3d9a6e811a0728d398e96e01d94fd7e5a955841c4f6fa79e52432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8558e650ba3ff19f980d020debec63fe80245accd613f399a68d7e4be797dee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = spawn bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db", "--addr", ":#{port}"
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
