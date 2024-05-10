class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "37e052642d4b9ed5b9e2dab01be852a127c6167b60add3c4542ddebe6f7119c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1a84b91c3daf1f4ee131dce3cf0965a61ba16024c1ebec2236d40bcb0631264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1624bc1739c1873aa15a1cf12d49c2374bf0eb7db04e2cc470ee35b0d661a206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c40a2a448fc2563c09fdf411d2fb5572797e3a0f78f053f36bb7059df867c0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e39e67b61ebf8441946dfafc2bd6df867a6a48939f347fd503f8f8087d28231e"
    sha256 cellar: :any_skip_relocation, ventura:        "835c456e11a9cc5522e80d77672eae2af72c3e1704fb907d3fdd2d7ddc34f796"
    sha256 cellar: :any_skip_relocation, monterey:       "cb8834fe061abe88e85ec1684c29aeefc523471e2e6cccab1d7357c0265fccfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c414f8de8da737a012071553931ac988b57405b5ac120c6e467fce43f7d5fa96"
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
