class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "54346203de134b084e0e15d100751ebe82a7c1aa97758191d70de8836b38f0fa"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d005bdc43eead1e5446e04a01795d22633b81bf462d84476a570a17f3a4f293d"
    sha256 cellar: :any,                 arm64_sequoia: "834a8da0be11db9f180a6c37088fe129410c17dc941d45fc4ed805772b73160a"
    sha256 cellar: :any,                 arm64_sonoma:  "9e4047467521b55041fe7d0ec973022b9f1b6f99b0b9ef0f81ab657babdc2c9d"
    sha256 cellar: :any,                 arm64_ventura: "76fc726bd5b11b48b6243718d6a4792b5eaa074474e7d84c80319f0e14c654f3"
    sha256 cellar: :any,                 sonoma:        "28cd1daaeae6c760aa0275451a92921074b4127f7ccb53f48302f5389ba9d864"
    sha256 cellar: :any,                 ventura:       "d2c328e9b93ea8eceed27952c71436485a7e0c79c20b75f7730b0c0b4844a2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2d5ce1fa76d2e9f5354f4e64dd8785e92a2c722c9a0f019a2bf75e01ca4599"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
