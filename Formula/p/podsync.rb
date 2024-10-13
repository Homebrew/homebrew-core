class Podsync < Formula
  desc "Turn YouTube or Vimeo channels, users, or playlists into podcast feeds"
  homepage "https://github.com/mxpv/podsync"
  url "https://github.com/mxpv/podsync/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "9852b5ef187f31f281c7968c644202770fb8f6f1b8bf5c91d811d486cac54a34"
  license "MIT"
  head "https://github.com/mxpv/podsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20be398a640998d4759372f56a4fd365e79eea1ca785366bd863700915177ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e01a9ac695520eec8a398618bc9b5eab8577e3bcbeee146e9c3f8f5ffdaaebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1eda2a20fd3c5697c4cce16248960e105b36603e6e5d838156bd5f9b47e3784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d61e7e03d5b60ea673f3065870229d9359eb2b6ac0ed5e4ea98a6da86ed0547"
    sha256 cellar: :any_skip_relocation, sonoma:         "602bba68f7ecc9dcfa776a522c80a64bf63df21efbf2a794f377789887d1efbe"
    sha256 cellar: :any_skip_relocation, ventura:        "5a0792de081350d678e627f2a6557e0c82bfd4d1a02588ea9d88c8dc062159f3"
    sha256 cellar: :any_skip_relocation, monterey:       "b68c090c3038e2b6497030fa3f9412aad1aaa22deee3fed78d1d0c5af1b7a7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21dd15567642059e94a37909abcb9492bb2e7c524e00f33f6f4a1a5b7acb1279"
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
