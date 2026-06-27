class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.19.1",
      revision: "6a5761f7e6c41ea2202696a0a683809b79646eba"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e3ef772e14e7183e7655179fd839005b9d9e8133e82ac8f9b8bff3283a672eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3ef772e14e7183e7655179fd839005b9d9e8133e82ac8f9b8bff3283a672eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e3ef772e14e7183e7655179fd839005b9d9e8133e82ac8f9b8bff3283a672eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb62ec1d83193327364d570a4b49cda9c69dd6ae009b056937cbe0af6e4d7e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d69891f9b127dae36a5963295a7ff5b7f7435ec84b7302f629ede4d57ceea4f7"
    sha256 cellar: :any,                 x86_64_linux:  "fa346ab543fc5ef1e5f38c0743589349d370580941b8fd03273e958c01e2279d"
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
