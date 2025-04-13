class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.11.3",
      revision: "b66efd66da92ce475f3bf2a229efa56724f3fa64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7aad648e383406142deb7063d3a22ee87db1fd138ba3d6d40b8cb7e956ba8df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7aad648e383406142deb7063d3a22ee87db1fd138ba3d6d40b8cb7e956ba8df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7aad648e383406142deb7063d3a22ee87db1fd138ba3d6d40b8cb7e956ba8df"
    sha256 cellar: :any_skip_relocation, sonoma:        "1753f47c73732b88ef50bd99f094f0267f49b43b19da44df4068bd57f6b6bd0e"
    sha256 cellar: :any_skip_relocation, ventura:       "1753f47c73732b88ef50bd99f094f0267f49b43b19da44df4068bd57f6b6bd0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7630819cf0eea100d4c0e0a1a5db3e7ff550afd67420c320653f6123a1fa64e"
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
