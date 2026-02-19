class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.16.1",
      revision: "4a559338ae69656b32ecf0364108b56d359bba5c"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b0383c4fdebef20dc970d708d3c3e768a1cba5ffbefedd40012266b509905a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80b0383c4fdebef20dc970d708d3c3e768a1cba5ffbefedd40012266b509905a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b0383c4fdebef20dc970d708d3c3e768a1cba5ffbefedd40012266b509905a"
    sha256 cellar: :any_skip_relocation, sonoma:        "59c5b0fb968579877818f22441d3d205044d8432fb190e003889be0f9f78c430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0d3a1a5ff06d34191c8c2bdc0f24efd7544b5f0741da7a49ef7a3e10150a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1c8fcb7e5976ccb99ee337dfb2a4a3f75776bede0b0dd89a61b5262d35a89d"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    pkgetc.install "mediamtx.yml"

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
