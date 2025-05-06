class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.12.1",
      revision: "66f36d966378b93b177ad12e6e49799a080d1971"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38009bef2a3fa951bc054838b2103cbe3480f141cde7bce4a62d93f737e9d794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38009bef2a3fa951bc054838b2103cbe3480f141cde7bce4a62d93f737e9d794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38009bef2a3fa951bc054838b2103cbe3480f141cde7bce4a62d93f737e9d794"
    sha256 cellar: :any_skip_relocation, sonoma:        "b01911fc5fc1c3524a982f432174582ffba3d8baf94ea32fcfe2540ad63ae994"
    sha256 cellar: :any_skip_relocation, ventura:       "b01911fc5fc1c3524a982f432174582ffba3d8baf94ea32fcfe2540ad63ae994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4133fe337f2e56a71e86cf5a8d390ecd2c867ef710460a43a2f273f3b137e0"
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
