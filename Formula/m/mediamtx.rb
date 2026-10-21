class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.21.2",
      revision: "914e39535ece709919ac325aaeed98d394ed9093"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d6e991c0bf95a93f310744a737a75dd3353cb69629b2f95125a820af74d2ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10d6e991c0bf95a93f310744a737a75dd3353cb69629b2f95125a820af74d2ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d6e991c0bf95a93f310744a737a75dd3353cb69629b2f95125a820af74d2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b1f3d5e11c04b3deed827f86bfdb0442dde938b0c9ecc0e502d7a68e5963791"
    sha256 cellar: :any,                 x86_64_linux:      "67ef93de436a30e23c3e968f1e82511119f1ff36657dac6817512a668fd53476"
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
