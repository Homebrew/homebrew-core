class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "8f5e7f6f6757ccf7d6c14b0525f414790d95467506b3115813207084ef8517a1"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02682ef18fe4bacafce9cc2152f27302a2bd88bf3de47c96a88441da49e579aa"
    sha256 cellar: :any,                 arm64_sequoia: "07ec9bd6e034dcc71e2118f8008cce9c039e6958988ebe28e2b3d37fde9842eb"
    sha256 cellar: :any,                 arm64_sonoma:  "8ffb62fa76f8717c07e54f75cad2019821196adf8a0ae43eb177e86c4907f1fb"
    sha256 cellar: :any,                 sonoma:        "2a8d8f1dcc8d3cf445156081e606226bd5927b194902c5d5c2ad8c979c2c0f41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a467f46c8eaff84df4c5fb02883afba772a50bee5e18d78061b9383cd000c8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5e674fd7d29822a46694f946226dfa12af26e36a5c4a22e2aa80810f6e7deb"
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
