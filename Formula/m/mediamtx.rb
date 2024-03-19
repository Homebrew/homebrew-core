class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "7eb2f94e6246bde435f19cfb56ac69926b7d700206c8491e0dd9c69e4324fe92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b62141e0731acab47e338c1e4c79c6dad92cbdfd76b9409ecbecf3c74835dd0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f6516b6d75cbeefa07f7aaf0b63a1be1452454380c8e0ac60e7922870390d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad21a144b56e21eedb3e8588a77c6a03df2e43c3fbbea8ccce252d60868d1a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddd831cba4b0fec9d43b44ec41d7a3843d7fc0738041e059be64e91f1ec88830"
    sha256 cellar: :any_skip_relocation, ventura:        "f3a373939c7c2fa27d1332334e70604566684eda01053c6371c880537cf28a31"
    sha256 cellar: :any_skip_relocation, monterey:       "547586e8d7a87727842369c26520f94c153dea3e2b796a7b54ae099b6552f7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a99c1eaa0fb695973a25fb2a6bd266e283009ab6590c5e9ebddbb2b707d4be"
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
