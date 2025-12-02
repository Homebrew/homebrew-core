class Podsync < Formula
  desc "Turn YouTube or Vimeo channels, users, or playlists into podcast feeds"
  homepage "https://github.com/mxpv/podsync"
  url "https://github.com/mxpv/podsync/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "ec23c744294884c8621faeec78b411f3434f75470986837a6b371ed05373204c"
  license "MIT"
  head "https://github.com/mxpv/podsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22537f59a33bac8bed4440849e3997a185fdcaf768e3866d16fecca40e83eb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b72aff6c92db971877d7d991633587ab3618b554ae58909aa8b9cc2e4abe66cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bc61487934281dcc05b9750a9c3ec8ac562e432acaceb1ab650f42ecd8c9971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ddfc6f47832c2496d85747da38144fb3ad2257920cdfe506984d9719b222c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "076d6a5b15d3928fb68f0f63ccdf406c139e55ca2ba0f2dcb6641d9c04e1e2fd"
    sha256 cellar: :any_skip_relocation, ventura:       "ce6b3c9f883b9d1274abd99d4f4cfb3f1187c14c425b2760067f87d5f92a4180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f94e0aeb79fdcfc692ccb4348fcbef0e589940db56313a41cb57a8fb2e4bc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85c76e45e098adc8b4310dfe93b9c3fc48cff6b54223743acd28beb8ac2651c"
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

    (testpath/"config.toml").write <<~TOML
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
    TOML

    pid = fork do
      exec bin/"podsync"
    end
    sleep 3

    Process.kill("SIGINT", pid)
    Process.wait(pid)

    assert_path_exists testpath/"podsync.log"
  end
end
