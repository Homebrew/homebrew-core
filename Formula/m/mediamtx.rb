class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.0",
      revision: "0ede14d1a144e039685c8b7eb66b24b6c8a5d036"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0af9efe9fa264bc44c50d11af8b421bc3aeb1e095471fe99aec815b90e141b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af9efe9fa264bc44c50d11af8b421bc3aeb1e095471fe99aec815b90e141b61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af9efe9fa264bc44c50d11af8b421bc3aeb1e095471fe99aec815b90e141b61"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69f9a24b2cb1f57d84fe10cfae95e28a451e8e62486d9a3984e854478f45334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4535c9ee1c2914f55231dbb736832689a8ceecaddc01a3a62fca20ff0073620a"
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
