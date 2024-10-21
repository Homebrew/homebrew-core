class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.9.3",
      revision: "6cd7487857dc6ee8b82cff1f45c900ad7e3d6362"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94aae3d4e5d4ad014fb5bdcd4690767f21f5ee83cfef99063c93851eeaf6b3dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94aae3d4e5d4ad014fb5bdcd4690767f21f5ee83cfef99063c93851eeaf6b3dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94aae3d4e5d4ad014fb5bdcd4690767f21f5ee83cfef99063c93851eeaf6b3dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "db9c2ec032c7cd88321b0de0db610c5e4e4908145570eb1413ed47b560f5f26a"
    sha256 cellar: :any_skip_relocation, ventura:       "db9c2ec032c7cd88321b0de0db610c5e4e4908145570eb1413ed47b560f5f26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d96a24648d3d00b865831c2ba915360f9a716d57d761508bcfa7d57117e886f"
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
