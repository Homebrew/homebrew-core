class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "17dcb04d2d7caf8c1263b124cf5ecb145d28ac6d0717c2de78c988858c0572af"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1cb6477b3d559878355d8aee5d23e36623bb2c44878dab54c0179d85cfc1e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32c79218206b64d1b5feb94b2c6d618f3b4419e4e637ce7473163652f6a185bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1310308f89b45f5a892c4b21522d4b50b61f960da3b55644ceb9aea46e2a80f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9862d9eaccab5f7a5eb5ffd86d943467c3c194197baa17ac8fdc25e7a8a664fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cdb7c9e6d4c813c394c42267ca1809e315d1b220e9e6d175965c91575d3e8a3"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c17e1a0e34777760d5bd364a5e8a36bb85012f5236694dda0574c3f0c3b523"
    sha256 cellar: :any_skip_relocation, monterey:       "43c9a1ab795584d898f476bd5a5e39fd70c21ffd96d10a1d70b9c199d4013d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a127061a6a8a2a731b2143c7d6f34a9a17d3a31e4614f4a2bc763b728d7c65"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
