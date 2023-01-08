class Podsync < Formula
  desc "Turn YouTube or Vimeo channels, users, or playlists into podcast feeds"
  homepage "https://github.com/mxpv/podsync"
  url "https://github.com/mxpv/podsync/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "45c3afea38ef45f665f456bc542ac57fecdafed884181156df6b44624b66d6b8"
  license "MIT"
  head "https://github.com/mxpv/podsync.git", branch: "main"

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "youtube-dl"

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
