class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "68273cf2a8938a167d68fd6c6b341f0e06c1f23acfca83698f5673048f9beaae"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7d8415155300d9b5a1550c5d207a6fcb0ed88f5206c94c2f0d2aa017789085e"
    sha256 cellar: :any,                 arm64_sequoia: "eb18a5a459650c3321f9dd4ad039db8454bd11a6be699b1edd1d3befd123d768"
    sha256 cellar: :any,                 arm64_sonoma:  "1bd6acf4cb673832a67fdb2c1d8cfd4a5f00bf85b2b47f18d15298980ec94f84"
    sha256 cellar: :any,                 sonoma:        "a754b3e1531df4fd122068b720e0a389e294627c3695b0cc1a4082a1ac3adb58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a0599fd96803ae2cee6fd1ca418da5332b1e60ee5e3519535ef4f578e840111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75be3fa53be1a1b8c6ad96bf7580d9d531e684d0bcaac1aef6f7df81f5521cd"
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
    system "go", "build", *std_go_args(ldflags:, tags: "netgo,sqlite_fts5"), "-buildvcs=false"

    generate_completions_from_executable(bin/"navidrome", shell_parameter_format: :cobra)
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
