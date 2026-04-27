class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.18.0",
      revision: "281593052960d12594dfe56bf9a4cb7b5b5e8fe9"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39fd14c416db82e82c0bb3162e05942d0ebc753f1afb8034f572383122bda295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fd14c416db82e82c0bb3162e05942d0ebc753f1afb8034f572383122bda295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39fd14c416db82e82c0bb3162e05942d0ebc753f1afb8034f572383122bda295"
    sha256 cellar: :any_skip_relocation, sonoma:        "9243982eadb1d90815d9352ad7cf8d84bdee4e259b431c3047ab5a890d2428cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fab1bd26f72c2489d11414a823af61c3cd215c3410bf03051ef96da2ffeedd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d037270aee0602efe9484ffc074737f0dacde037be0bfcaab6a852bc28fd587f"
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
