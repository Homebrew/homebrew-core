class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.14.0",
      revision: "c80220eb7c91b74a828ca231b27412005db51f68"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbfe6a7157b15c1be806266aaa0d69d2568ab8acedb5de463086941d9255a1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f0b14d4dbd741ee00d25e7d2970dcb507e90148c0caf98ca9d43441a7d0a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5f0b14d4dbd741ee00d25e7d2970dcb507e90148c0caf98ca9d43441a7d0a7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5f0b14d4dbd741ee00d25e7d2970dcb507e90148c0caf98ca9d43441a7d0a7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "afb7df30f4006e865fa1e01897b6926888436b814add67d58709467ff4a639a1"
    sha256 cellar: :any_skip_relocation, ventura:       "afb7df30f4006e865fa1e01897b6926888436b814add67d58709467ff4a639a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbefdb547eba8051da9fe476acf4bd924c3f8d64dec8f25aa6e41dda305b61b5"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    (etc/"mediamtx").install "mediamtx.yml"
  end

  def post_install
    (var/"log/mediamtx").mkpath
  end

  service do
    run [opt_bin/"mediamtx", etc/"mediamtx/mediamtx.yml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mediamtx/output.log"
    error_log_path var/"log/mediamtx/error.log"
  end

  test do
    port = free_port

    # version report has some issue, https://github.com/bluenviron/mediamtx/issues/3846
    assert_match version.to_s, shell_output("#{bin}/mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
