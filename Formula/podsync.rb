class Podsync < Formula
  desc "Turn YouTube or Vimeo channels, users, or playlists into podcast feeds"
  homepage "https://github.com/mxpv/podsync"
  url "https://github.com/mxpv/podsync/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "45c3afea38ef45f665f456bc542ac57fecdafed884181156df6b44624b66d6b8"
  license "MIT"
  head "https://github.com/mxpv/podsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76dee7bd62d19d34071c9a8fd1070c5261d9272c3f99dd5e95db8cd150918f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2f5f370c46fca60362176dea7216b6e5e9900807e7e673a132a889336a9501"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3cce5fdc39902ed6a7798cc71fd892b7c88137093affcd17d2a6d0afc3d045b"
    sha256 cellar: :any_skip_relocation, ventura:        "60bd7b4dce3c53d91ecd766c1b6d5bbbcd9de8e1f2b95764c34e304bb6b9ffc8"
    sha256 cellar: :any_skip_relocation, monterey:       "327ac5922537c111be107e7ace237d46952dfeeb66d0cb1f165b1461555b38eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8004395d3838596a143272c98076893f75ea2c7a78192d1b893cbe6f9dfad9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ed45e3d194c0ac8878ebba0582ef99d8a6b98881a0babd2af56f808121fb4c"
  end

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
