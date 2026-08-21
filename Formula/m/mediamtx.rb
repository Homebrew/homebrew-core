class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.20.1",
      revision: "883194a19b7244355c9bc975c0574c9842733637"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a527f2842c0da5dcb41cbb24970df3aece1fdec09fdd4555b366231c9a20a23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a527f2842c0da5dcb41cbb24970df3aece1fdec09fdd4555b366231c9a20a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a527f2842c0da5dcb41cbb24970df3aece1fdec09fdd4555b366231c9a20a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ce2887317af1e1a490ced085864c9bb796431fc4c54af3623ea09787681cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6ee206b19b7d5ddf7c33fb32709847163d41e38e634cba08d3ab2e25a51d22"
    sha256 cellar: :any,                 x86_64_linux:  "db3bf3e86e5738d7f752348f3fb0c4f24a35c6ce2167eec9a82a81071e299f76"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args

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
