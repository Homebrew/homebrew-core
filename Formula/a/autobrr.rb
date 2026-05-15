class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "f26ec53a61d9d8450919167bc9f0a3f43ec1e81e12939d738805dfe8e545a392"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d91b0c9eae29ca05dda917606bd36bad3e1f0da378a605b3fddd7fe8cec5b553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5803f47030bee16fa0264bb4d13f8911aec427ae96a59a954ef157e7e0791a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0a74dd9a221a529880194b75aad6d32d7d997ed92913baf3ed7af50f8a67c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a96421ef61e07bd97b1b142d03f67d0440d94dbe677e6275aa1f7dbab9e84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afe4fbc409ecf85f9d4e2532fb167f9619f2a1524b19e8ed99783697c4a3f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129c3758ce52e85089b19fab4cbfb381c02e512aa6b4d1157ca3de6aa5313fc4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
