class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.21.1",
      revision: "048255986f7e04b859b4c4efe651448ec785ecd4"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c89fb7628d491ff584592b4b1d75cd97e1c30528e274f36345c9733467ce95c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c89fb7628d491ff584592b4b1d75cd97e1c30528e274f36345c9733467ce95c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c89fb7628d491ff584592b4b1d75cd97e1c30528e274f36345c9733467ce95c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d4988829b900791c807466f27f43c9b562119dfc5307a6ce098f7c9898c87f5"
    sha256 cellar: :any,                 x86_64_linux:      "4748ad53a07a698717f2a5025c3287232132f8171ad7386ac2a40de2133fc444"
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
