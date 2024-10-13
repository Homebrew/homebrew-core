class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.9.2",
      revision: "32d3fc55ccc631ad125462063b7bf387595209fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55994a5f8b83fadb20ceeaf20fb56c81048b9e31945418108d67c04fb78ca8a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55994a5f8b83fadb20ceeaf20fb56c81048b9e31945418108d67c04fb78ca8a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55994a5f8b83fadb20ceeaf20fb56c81048b9e31945418108d67c04fb78ca8a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "067bbd596e8fa826a9c90631bb1808413b5cff232bc3446241f5b4256dd64719"
    sha256 cellar: :any_skip_relocation, ventura:       "067bbd596e8fa826a9c90631bb1808413b5cff232bc3446241f5b4256dd64719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "173e617560b1d7ee8f711354a9a7b5799f55d9544e5e32d41a521bc096f58210"
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
