class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "01367a6cf96f4bcb959f0cba82e9e88b4560be8caf3f4019a6416e7d2f7dac4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d6f486fef28897283000189b671815f35225365125b4207fb33b27a65d944cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a68e148514ed0f9158dbe3b451e690eaba5a6b031685e7e85a4542a38d33b132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bc3665dd0cdc197a6c6743f98ae75724052caca9773c6d18932d06d15720ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "14cc65e20cb0f57977da8b48f4718f054d63f6e1426c068a5766823579c7b464"
    sha256 cellar: :any_skip_relocation, ventura:        "ea640fc3a6ac9210dc7fe23af816e50e65370d7c50c3b87f500d30b1870d06fe"
    sha256 cellar: :any_skip_relocation, monterey:       "876b5fffe95ba343faacba0d0cbf9c574f6472bc012a3862d96668cd9096ae7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2db54830006b1ad750f0c6f8e3f38d215c1c6b376375a3df28a3ed7439cc8a36"
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
