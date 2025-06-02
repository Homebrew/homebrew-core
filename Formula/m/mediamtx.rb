class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.12.3",
      revision: "bcebc4d2ef6835ebdf5beb8510552857a6a2e49a"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21aa5c2f5cb84428c81e13baaabe605936082ce9e16156061a0df7f756629770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21aa5c2f5cb84428c81e13baaabe605936082ce9e16156061a0df7f756629770"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21aa5c2f5cb84428c81e13baaabe605936082ce9e16156061a0df7f756629770"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e472112e1d9b632d50c9e497277c7fe33e20efde222611b60a5dc60e31a103"
    sha256 cellar: :any_skip_relocation, ventura:       "12e472112e1d9b632d50c9e497277c7fe33e20efde222611b60a5dc60e31a103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b64507748bd23ade5f78dbe18d2b6f5667fc5a35b7658c31dd9a9608edb09cd3"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

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
    port = free_port

    # version report has some issue, https://github.com/bluenviron/mediamtx/issues/3846
    assert_match version.to_s, shell_output("#{bin}/mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
