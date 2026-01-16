class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.6",
      revision: "62effa79efc7eb151434e3de6ef9cc2501c204a2"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bbb80ccae121e7e96aec8160bbdf28142791ed8ee1595eb70347ab63f916e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbb80ccae121e7e96aec8160bbdf28142791ed8ee1595eb70347ab63f916e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bbb80ccae121e7e96aec8160bbdf28142791ed8ee1595eb70347ab63f916e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "16afb82fa94df991dd9dd4ac8ec386ba99430989dbf670366a3d4bcd614cd3c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8720e2b7860ef4c907ac2bbb2beb6c981f474cdb1899b871150c43722ade61fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc5934edb5a07540c07fae0c3a3d36edf446bca9f77b22815e6b32a3cdc4dd3"
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
