class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.12.0",
      revision: "dd9a5caa7b723885e49da3281afdab2bb1a8dd88"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e9148d7ccc672a289a4448840a9987ab799438f14b1a06612008e20e0e10d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e9148d7ccc672a289a4448840a9987ab799438f14b1a06612008e20e0e10d5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e9148d7ccc672a289a4448840a9987ab799438f14b1a06612008e20e0e10d5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e07b1ce98262af9bc201b05777b18ffeed2a1c80640853b971bae6179be22bf"
    sha256 cellar: :any_skip_relocation, ventura:       "6e07b1ce98262af9bc201b05777b18ffeed2a1c80640853b971bae6179be22bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4640be96c0d56eba2545bacc0ee4fdccaf87a516287b38134f2472f7cff37b38"
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
