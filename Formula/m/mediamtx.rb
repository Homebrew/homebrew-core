class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.19.0",
      revision: "b5b63d02fc1c55096cf5a035207d6e5694d1ab4d"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06211308bafe37ed9a63fe772c0f909d341907c583953ecf528605db0df2b269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06211308bafe37ed9a63fe772c0f909d341907c583953ecf528605db0df2b269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06211308bafe37ed9a63fe772c0f909d341907c583953ecf528605db0df2b269"
    sha256 cellar: :any_skip_relocation, sonoma:        "46eff6e5c13a19f68c5d3a8cb4b8247bf8a7b11d220f0492498a5ec66bfaa1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94b1a645b778cfe5fd03cd0f8746f22066a518ac2cfc1bfb7cc0a3a204d4109a"
    sha256 cellar: :any,                 x86_64_linux:  "717ad7c820a7c35fee94104594924248b2a771b02613f7937b75535c78b78bc6"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    pkgetc.install "mediamtx.yml"
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
    pid = spawn({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", pkgetc/"mediamtx.yml")
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
