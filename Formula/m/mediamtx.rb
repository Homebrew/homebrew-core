class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.21.4",
      revision: "e65f9411a56b19076a0dfde1fb4a59414bdf642c"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    manifest_sha256 "57319a5e3297e01d0eb811f51a42def68b4a81122436f7826bd2e2897133a805"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebeb27ecfaa2ac1d0fe629bc0062861ac3dea4536efb5775cf407cf8a9307eac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebeb27ecfaa2ac1d0fe629bc0062861ac3dea4536efb5775cf407cf8a9307eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebeb27ecfaa2ac1d0fe629bc0062861ac3dea4536efb5775cf407cf8a9307eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eca97df9cbf5b8287c0409493778c93b394c327b07aca7e3fc17632e854acf89"
    sha256 cellar: :any,                 x86_64_linux:      "7bbcffc9b07ee2c24446e15b490e8c02a381cfd4d0cf2e0375baa4801d7465eb"
  end

  depends_on "go" => :build

  # `test do` block queries the API of a local mediamtx server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "go", "generate", "./..."
  end

  def install
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
