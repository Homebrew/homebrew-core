class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.1",
      revision: "ead4dcd6f80130b95a603eb53e953c4248bc5a19"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ad5090ce535e69f9dfc28f8aae9e272ca36ce8a1c1da37950a27fa384144c42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad5090ce535e69f9dfc28f8aae9e272ca36ce8a1c1da37950a27fa384144c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad5090ce535e69f9dfc28f8aae9e272ca36ce8a1c1da37950a27fa384144c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa7b815507ade4a675722637ebbb582477288ce52f1219776593b74f57c5c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62c3b9fad3a725b737ea3f56942709fc333aab62085a5d19777b58ceefaa27f"
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
