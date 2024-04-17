class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "14ab5cc78783cf61dbcca3a9a2d630b3649d3249651f429e40e30a9c23da6271"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e771fc284a23e5f909693f7dd81573ac8f59a0183f55b35cf914dd7df82f609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb0d20714a16b439fbbf35b8ec2b9c870a4bc65803e0ad98d1a30f1397eeb30f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17a7c454b8bf2f33a4c97a5b3f0e968ebce31849aae3e925e2a67ce40b5620cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6775bb0bd1a5714e64b8d924f342d31220e457df24d570c793ef711c97f2f02"
    sha256 cellar: :any_skip_relocation, ventura:        "79d49a647731db9f4893de56b25ce657d2b807fc08af01ff7fd1347d5655fbe9"
    sha256 cellar: :any_skip_relocation, monterey:       "0206bcb4b3e65b2d92d225e7ee732ce0401bc48fad312c0f9a044ee85d79a0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dcc2484e78476f9f8f85ea9b4dc96df6c829bbc951e8ab35d59224989d32d59"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."

    ldflags = "-s -w -X github.com/bluenviron/mediamtx/internal/core.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
    assert_equal version, shell_output(bin/"mediamtx --version")

    mediamtx_api = "127.0.0.1:#{free_port}"
    mediamtx = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", mediamtx)
    Process.wait mediamtx
  end
end
