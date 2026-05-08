class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.18.1",
      revision: "dc979a0be8b9f494c6a74996739b5e4e93c8e13b"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f66b160a5ab8cbe551efc1adea0c63af1f04053dcbbc37109567a875f5a2174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f66b160a5ab8cbe551efc1adea0c63af1f04053dcbbc37109567a875f5a2174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f66b160a5ab8cbe551efc1adea0c63af1f04053dcbbc37109567a875f5a2174"
    sha256 cellar: :any_skip_relocation, sonoma:        "664feab419b927229777cb0099d79ab4dd1c7a5c168bfa1ffba2a263a5adb2d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8edf828926ab8813137565009a48af1391f4d96fa99d7b8f46160a78823169e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4856bd345f51ca4a876758e51455b2792c9e7a062745f7c5dd4f5eeba7b3a9dc"
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
