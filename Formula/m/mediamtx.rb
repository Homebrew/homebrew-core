class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.17.1",
      revision: "5addbed337a884d05ae7eda056c2f4397e3ed874"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23be24bfa8e8e783fb2f3e05763738b41cec269a853098ff1e3563b8ecd0ffb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23be24bfa8e8e783fb2f3e05763738b41cec269a853098ff1e3563b8ecd0ffb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23be24bfa8e8e783fb2f3e05763738b41cec269a853098ff1e3563b8ecd0ffb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ccecaecefcd856448761356d4295050b2388f99ec98d13a0fce9b52298e06e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da6636f38d17cf3683b4de06caa84db1087f29f345f0a34b5d03a154d349f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04bc5cdaba98359748a7634ff9a7eb83aa14ba5ac9e28ad069373f02fa846103"
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
