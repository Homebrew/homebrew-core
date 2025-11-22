class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.4",
      revision: "697211332ac8047c38245b9600a628db951d9a33"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1afa768a6489879f90196eedc0cc83e487b591d71e02ff3dbbedc9143512fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1afa768a6489879f90196eedc0cc83e487b591d71e02ff3dbbedc9143512fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1afa768a6489879f90196eedc0cc83e487b591d71e02ff3dbbedc9143512fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b23ccb93960434814d386a9d49c2268078e709eb2e8773a9871c2894da20a9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b1e6820c785b87a3d243f1ccbd0800be0098fae1c9b2304d2870d7a3f8e5e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "032ff9faa7843076e19eed05d4b93cc0b2d94e4466673b67056a6e9ef6559f6c"
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
