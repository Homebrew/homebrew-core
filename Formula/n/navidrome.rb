class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "e0d5b0280c302938177b2241a5f9868a4b40cd603ddf5acb2ff0f9c40e44c13a"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "544d6d2a8308f121a8ed3b475dc28d4fdfc5fa0d0cf96af7d78a0578314206e3"
    sha256 cellar: :any,                 arm64_sonoma:  "60131648342f76dda38a1815d9ec9bed3c6f9452c91d6f144d3e3191da16b257"
    sha256 cellar: :any,                 arm64_ventura: "4368d6cc4a4cb0f6b5adb5ee75912b2277e7949c7335e6480d24d2ea4bd81913"
    sha256 cellar: :any,                 sonoma:        "91ea632fa0a630154203bb4ee4a5fb503c72f3cc9e0f1359ad5f6846fd9b76bd"
    sha256 cellar: :any,                 ventura:       "7ce4dc50dae686e0acc0c77e27c14a1203ab3f8dc1ada4ab2ebb01a5e13d12c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb76a5c3808cb67a7c170d9abe8a4da63020ee7dcfdea3a8d00cbf4a6b5eef8c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags: "-X github.com/navidrome/navidrome/consts.gitTag=v#{version} -X github.com/navidrome/navidrome/consts.gitSha=source_archive"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = fork do
      exec bin/"navidrome", "--port", port.to_s
    end
    sleep 15
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
