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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1ade383aab72ef34bda397301a99791d465d74cb77f1894f531f75b5b8d378b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1ade383aab72ef34bda397301a99791d465d74cb77f1894f531f75b5b8d378b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1ade383aab72ef34bda397301a99791d465d74cb77f1894f531f75b5b8d378b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bcf074053e2b0944e41a0937f3663c4304e99b31b1ac90492b7b9da324d0824d"
    sha256 cellar: :any,                 x86_64_linux:      "790ee2ec84ed204625e87fafeb4442c53f4c83a4f062e604fa81de3326edb763"
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
