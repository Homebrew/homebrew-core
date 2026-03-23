class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.60.3.tar.gz"
  sha256 "afb07417b2d38ee6d757bc4e1ea1ff635f2666e149c44a883560a5bcda2d8556"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4377d4b038741e364d4a999203535693751245156c44faf2b2f38c834aab1ae1"
    sha256 cellar: :any,                 arm64_sequoia: "c7660513e9613acb671d35c93185e19e864bb7d10909917cf9a5952a3fadf58b"
    sha256 cellar: :any,                 arm64_sonoma:  "28bbd739a694231714a471439610481695f572de8159e31d43458843a5855759"
    sha256 cellar: :any,                 sonoma:        "99c826707517a5115d53ad5226f6999858bb1edf671e816896abb5d1823b6673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53618093f2d2d82edf06d9a400e8c1851e708b207cfb727ba4635bb4c119f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be972c8527b6bbdb10f08ae3e71bca6037686258fd1693619258fdc6b3f4e765"
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
