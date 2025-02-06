class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.11.2",
      revision: "a8b8f676f4acdb37b5eaaf4a20213901c78baad3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fc1ebe514b4044fa4aa89ea4e61df60a30e4f2901a8fb51c6bc34f051c3f165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc1ebe514b4044fa4aa89ea4e61df60a30e4f2901a8fb51c6bc34f051c3f165"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fc1ebe514b4044fa4aa89ea4e61df60a30e4f2901a8fb51c6bc34f051c3f165"
    sha256 cellar: :any_skip_relocation, sonoma:        "b804c3d82854c3ab07353849c22a60d1a9087a76b31e58020f67b1dd26b2c9dc"
    sha256 cellar: :any_skip_relocation, ventura:       "b804c3d82854c3ab07353849c22a60d1a9087a76b31e58020f67b1dd26b2c9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e652f1d547e470be6138c4efd9ed5dccba4eb2dc42190db1bf9841d56725d8a8"
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
