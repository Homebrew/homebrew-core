class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "b2a61c975029e59981cc2b443d9382ef92526325dcf26f82c9dd4b004454736d"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4db8bc06422e7d805dd99e5d946c4acaeb508a41bf9808ebef753a040347a92"
    sha256 cellar: :any,                 arm64_sequoia: "0a49819ff22b164cb4209624aaab9cbaaa88e013fcdace1a8a31b9126a97c98c"
    sha256 cellar: :any,                 arm64_sonoma:  "fb591c0b27168ed2c25503b66de0ad93a2ff452b8576115a3b32f13474481ac4"
    sha256 cellar: :any,                 sonoma:        "52066f7511bfa7a898ffd0db3c8f00505551350d3e03ae91087aa42a87da06e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402a7af009cde05184576835e6fc9d79764ebcece719f34af552c8b2dbd3a0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edc5cc38852a287ef7c892784ca047461416e932f4ca8298f4d063e16cea43b7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
