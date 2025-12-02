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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ef85884b54e9213cec79d019d34fb2333d54498f56c8837cc309a308fa3a5bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ef85884b54e9213cec79d019d34fb2333d54498f56c8837cc309a308fa3a5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef85884b54e9213cec79d019d34fb2333d54498f56c8837cc309a308fa3a5bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "baf630e3dbd8e26d57470c0632af002c0fc2421fd800f12c256904ca56c756e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ebce8f85bc15f10c97887ad06007dce5c0979e560cdcdbef62410199072e1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd8c39d456dc16b065c2d76d1c7656423726854139e4263d554be0f8d60b2b2"
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
