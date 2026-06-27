class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "4e1d3c8cdb5b16deadbe2e7b29f6cc147aadc466a771eb929daec95153ac1cb0"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9d63571f4dd4367bf583302583f65e0eabffea57e7643077e560e0b06043ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c427b61bc9acf38e700e39ffa91d8be2c29a4cd3f16cc090d2a6596ed418b47e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a7069ac28c7dae89f507a0254cbcad8585caf242fdfbf0c759e9045debdfd99"
    sha256 cellar: :any_skip_relocation, sonoma:        "66f5fcd1380e4433980aff601dc51635188ab1149cba09526174b8991e6a3d30"
    sha256 cellar: :any,                 arm64_linux:   "eeab8d7555c3a19221d14bedf4692d4add535680e37828f73f7802f7ca6487d7"
    sha256 cellar: :any,                 x86_64_linux:  "0efc7038bc25d744ab90f27ccf9237509baf2d4d5df6d88a041517f6d2e3452c"
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
