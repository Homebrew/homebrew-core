class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.17.0",
      revision: "2b302e7940107cea87fe85ab8cb3cedf891d8ac2"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "356224bd573818b64f0179926f7b106a32a45db35654c236ab13eee891e7a951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "356224bd573818b64f0179926f7b106a32a45db35654c236ab13eee891e7a951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356224bd573818b64f0179926f7b106a32a45db35654c236ab13eee891e7a951"
    sha256 cellar: :any_skip_relocation, sonoma:        "10b159d1c13e09aef2d1b50e06d566fd1eb9725e35702062002c157dc4820d0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9972843b12b63228d3c39ee2e95eb73e94e4e928c45762752c5b1cb40dc2e38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31ff23df48a4836e03ec233f616dc516884c7071361e271457a776336d3bbda"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    pkgetc.install "mediamtx.yml"

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
