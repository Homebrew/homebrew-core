class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "2a217992d997570bbbe610401a16a66a30a25710b3a43bd5f67beebe80ae553c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5264eda8104a3938198aaad6695a4adaf8641a82fa1ca003a8a586352387258d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51981621c328fe7f174c52538eb0661b257ec93084173fce746c1d2af4449109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67a8cea159c1cb621c1d502bb91789a1a433ecfb695aaff8e2e97493bc372103"
    sha256 cellar: :any_skip_relocation, sonoma:         "450ee483f587aa930ab3340e22417609c6e8febee65f0cb2c6506fd6039e8cec"
    sha256 cellar: :any_skip_relocation, ventura:        "de12005f80d5436e5ce1d4e988296d130ef58d0291bfb1e571cc22bd90276510"
    sha256 cellar: :any_skip_relocation, monterey:       "90cc79f1c29b85fd1a77b2d15bd6f1b44e79e05ea51d021cdb2acb262bd0ff3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97bfd5c6067bf56ad4545556a118beca0e7660dbb7554f20ca439f0e58e2d95e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/bluenviron/mediamtx/internal/core.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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
