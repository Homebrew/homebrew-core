class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.21.0",
      revision: "2c6727904fbf233615de74a6c54a9b94dbf6025d"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f266b0c23a91e26fff3cd4f09791df6f3363e7acc6c138864678f07abff74799"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5c2bddcc1cb25b4e239147054e83312958fa674243a5b0e488e79aba6cb0559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5c2bddcc1cb25b4e239147054e83312958fa674243a5b0e488e79aba6cb0559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e5c2bddcc1cb25b4e239147054e83312958fa674243a5b0e488e79aba6cb0559"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb3cb875de337dba5149ca3cc846e684cb007c74d1c16c0b8580f2eace66435d"
    sha256 cellar: :any,                 x86_64_linux:      "38bb579aad8529bf38edddafa3ba19a4fb9126c3708e7e15b3dba9f105e8785b"
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
