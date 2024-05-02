class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "5d6ce0b1cf632f679bc5c0c1b4a6b4464cc640c7d9cd3263a58455f0930bea26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f6806bde27faeaffba203a0457ac72d77cadab8e3a26c2843f55e67e44cbf42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8b1b00993e5139a072831943349af3bb1742714496fdf475a8a630b1a1206f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb545550a8b927cd1f2b0d2e473a2b235289130d830948aa26f4c2b5d5406f60"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aca5ae83b192c5d6a8a02262ebfff9db98b9339c0eb242416ca57d683d969da"
    sha256 cellar: :any_skip_relocation, ventura:        "a7bb02c70cad8f4fef1b94e6a2bfc98d9a4375714708c6271a248a59be72be37"
    sha256 cellar: :any_skip_relocation, monterey:       "da206dcb696995e0d2ab1742519bf1f28d58ba560745d5af195ea48cf7672468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ff7da09952393ac050d68ffe9cbfcb14be51a7be88c58913f2fa812cc017ad"
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
