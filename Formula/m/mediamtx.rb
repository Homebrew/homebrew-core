class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.13.0",
      revision: "9d21847f34b8d286e3eb47db74b055318265e360"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "204460eba0e4dd9fe87b79819a941e16920bfe209afc6689e5be934ab1cacfb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204460eba0e4dd9fe87b79819a941e16920bfe209afc6689e5be934ab1cacfb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "204460eba0e4dd9fe87b79819a941e16920bfe209afc6689e5be934ab1cacfb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e2f868adab59b637387403f5e79c27a863c5aea24e5c0924936e52583b7bc0c"
    sha256 cellar: :any_skip_relocation, ventura:       "7e2f868adab59b637387403f5e79c27a863c5aea24e5c0924936e52583b7bc0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf775afb0269ec3795424b24a4191089bc6c42ad30fd55171f673f932f1b389"
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
