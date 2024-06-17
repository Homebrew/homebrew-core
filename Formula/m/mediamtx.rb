class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "b7f7573b196a00c7a1017af91f9e6e2749138339d4b7702aeff4b4a7a4d45b59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66fcb985945c7de9fa309f13ee7482383c24ed4bffede032950d13daed19d722"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d63c836c27fb4272cc3f7fe54d1d94bf9f92646b4425ad1f39304adbb3ebdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c77b3ba669b8121fc3ca73a608f86615cf959b01446364226207b1aa76c20ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "55d2c67684c511f59f98856034f88d652f83e79a257bced2c59bc9f4f832a30d"
    sha256 cellar: :any_skip_relocation, ventura:        "5c271f5faa533aa7fb1eb0d4c51c24a1576a341fac580174b0444a2543094e69"
    sha256 cellar: :any_skip_relocation, monterey:       "7eaf2a9604b009ee674d892180bf2c8ddbb5cad53bbe1bc4e68e708c4ee95cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646ce20c9908d818ba992928e6401a38e291672235c5a43e79e0cb1400edeb9d"
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
