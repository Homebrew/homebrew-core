class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.9.tar.gz"
  sha256 "1169377621ccc4e552c7a55f12f03bf7bee0df28a1cf60a1609017723018e4bb"
  license "AGPL-3.0-only"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c83a06eae0fbc270ddb34dd279062a1416ad1b9e19fb806946d24a8296e5fb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c83a06eae0fbc270ddb34dd279062a1416ad1b9e19fb806946d24a8296e5fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c83a06eae0fbc270ddb34dd279062a1416ad1b9e19fb806946d24a8296e5fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2137b07aaee21bcc42ac1c292ee38dc1e4dc6c9edd4d100426adefc8467e76ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3444a94d4b08f460552b034a7b5e33f22083e10a18e7d9c9c9062e0a17d97f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895b9bb9c58ac50967a72be03b5decf82db2449773ba79b525fa9d53450fce07"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")

    cmd = "#{bin}/clx article 1"
    assert_match "Y Combinator", if OS.mac?
      shell_output(cmd)
    else
      require "pty"
      r, w, pid = PTY.spawn(cmd)
      r.winsize = [80, 43]
      w.write " q"
      Process.wait(pid)
      r.read_nonblock(1024)
    end
  end
end
