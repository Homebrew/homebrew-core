class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.19.2",
      revision: "7eb5d30075ae68a36c07c3f1231af04a0e49f804"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1dce88c3ea5a0d7036219794272df1fc59f3bf4e3e3da5b8d259e95e286edf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e1dce88c3ea5a0d7036219794272df1fc59f3bf4e3e3da5b8d259e95e286edf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e1dce88c3ea5a0d7036219794272df1fc59f3bf4e3e3da5b8d259e95e286edf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0fc6dbe74e4b15cb1bcea1da9c60c7ac7375ff43a46c10e27bf6a0c8fd00ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628cd70ce826ef2edd42d28fc5497ec7b9bac981180cb3188a966d7e9a1d9996"
    sha256 cellar: :any,                 x86_64_linux:  "3c4a2247ef69f15c12aba4f22e571605d60e8d256f0f2c3a13a11e69ed74af50"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    pkgetc.install "mediamtx.yml"
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
    pid = spawn({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", pkgetc/"mediamtx.yml")
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
