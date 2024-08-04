class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "29fa6037e82755594defc72ea9f02d5ec7df09a30a52c36a24871c75b571739a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87e86dbafa39272fe0dc53d2636047022290efcc32950ad5728ffdc7b20b493f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c21ddf1118870383157c72b71b9e57481336e27e357a9cd568432cc8a5a9ac3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddab034a85a5e081c888403713d36a65733d5a9c8d67cc58df3ade9db160f31"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a9579ddc38b6ba15c53dd64527dc7d2acd2bff6e6ebb0cbbdc98539e6304d06"
    sha256 cellar: :any_skip_relocation, ventura:        "52989e7e5173a459c3a2132878ab12c13afa1f0080762f199353b4acc20cd3df"
    sha256 cellar: :any_skip_relocation, monterey:       "d6db5bb03db5ba9b3c9a4c56bd4045c7526646cfd0b630b112ce10d252135491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a0cdcba53e9aca69e2a0f2bac2989748ab5ec308fcd35c1ce62f4a30fb9b7f"
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
