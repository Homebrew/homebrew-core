class Podsync < Formula
  desc "Turn YouTube or Vimeo channels, users, or playlists into podcast feeds"
  homepage "https://github.com/mxpv/podsync"
  url "https://github.com/mxpv/podsync/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "e9d1653c4b8424b8f02dc1812c2848cfc930f400e996979464228cad0e16ec9b"
  license "MIT"
  head "https://github.com/mxpv/podsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a819193e880f0f54cc926c324090b6aac012bced27e47c6835fde49065c6323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c739b189bc243d5b1622a720066048bed929054b795dabd1867b115874c6c4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac8333f73a2759b122a74d7b975a0afc50116913aef8726c3967a982325368ec"
    sha256 cellar: :any_skip_relocation, ventura:        "b1465d7d2e3d055a8b3f1aceb2f1d6ff5cbcd0a82f49cc9cbb5b52a99ad12baa"
    sha256 cellar: :any_skip_relocation, monterey:       "5710b2f920b20e94d6322751dafaaf459535a9b0e7b806e9df974b7b484e1045"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff9eb8b1d9bde58246be6dd3b71c3c442814d348f4ebd55a01ea3a5ebbf737f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f364100244c9a0360063b065cd0f0868ba0ab914ae4176b00d1aa4b6641a0d02"
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
