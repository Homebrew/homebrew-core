class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.58.5.tar.gz"
  sha256 "24feffb3565a6f62ce04bd51e789352a8e4a3fe830459da4a42ba726a439b559"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e45a1f971f52e025dda9eb74d9d101ce480ad3d10510cf6db1c725a8461b10a"
    sha256 cellar: :any,                 arm64_sequoia: "61fb90b15e074dad6036038124fda87eb103d5a6a6b6795da534dd63c26d9c33"
    sha256 cellar: :any,                 arm64_sonoma:  "0af3782e018b4020507aab3faa1151667510a87766f795117c6d3d075597ddc2"
    sha256 cellar: :any,                 sonoma:        "891250f528e322b981cab65dac52016eebedf4014306d1395e9ca2e99593213e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8d8b086608ecbd8d1d18acb0c5148b336be9e52097936b2b2bbd2495310b039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2e778b1f294c6817a1cd7db17a0d2ff34c979fd5135e84bbd908a29c106ef4"
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
