class Podsync < Formula
  desc "Turn YouTube or Vimeo channels, users, or playlists into podcast feeds"
  homepage "https://github.com/mxpv/podsync"
  url "https://github.com/mxpv/podsync/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "e9d1653c4b8424b8f02dc1812c2848cfc930f400e996979464228cad0e16ec9b"
  license "MIT"
  head "https://github.com/mxpv/podsync.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c652dd561e4e4f06ad16976a5ef80240ff9a8421d3e8fc7545c4611795d56e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45265fe7a6f2afb29ba72bfdfbc5bc8bb9232f224b5f6fae36dadd2491188d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8a32141e3799be613ef73ada6723efa2e092a2656f61c92084a0a0021c2eb4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "db3a764badcaa09e98fde8d8eef16877bfa6a226fd4e5f8b6568730370b0eafa"
    sha256 cellar: :any_skip_relocation, ventura:        "bcd513a3e5b67bd3d0b3aee3938c328af6aa486ea89e1b500a6fc778340d5649"
    sha256 cellar: :any_skip_relocation, monterey:       "da08f2252e6462694fba0ab87e4f50097cd9f478d7849decd6e67e6ee7dfd74d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad6e258c694031312fcafa59840ed7fad01d869f44dd33dd2d41571ede6951b"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    system "make", "build"
    bin.install "bin/podsync"
  end

  test do
    port = free_port

    (testpath/"config.toml").write <<~EOS
      [server]
      port = #{port}

      [log]
      filename = "podsync.log"

      [storage]
        [storage.local]
        data_dir = "data/podsync/"

      [feeds]
        [feeds.ID1]
        url = "https://www.youtube.com/channel/UCxC5Ls6DwqV0e-CYcAKkExQ"
    EOS

    pid = fork do
      exec bin/"podsync"
    end
    sleep 1

    Process.kill("SIGINT", pid)
    Process.wait(pid)

    assert_predicate testpath/"podsync.log", :exist?
  end
end
