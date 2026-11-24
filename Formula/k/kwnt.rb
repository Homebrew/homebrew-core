class Kwnt < Formula
  desc "Self-hosted team of AI bots with handoffs, approvals and routines"
  homepage "https://kwant.si"
  url "https://github.com/alexsergivan/kwant/archive/refs/tags/mac-v0.9.44.tar.gz"
  sha256 "629b28bb8557cfb429881edee27fd163b854b425c56fbe39058df2a098a5f6e9"
  license "AGPL-3.0-only"
  head "https://github.com/alexsergivan/kwant.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mac-v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    cd "frontend" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # The kwnt binary embeds the web UI from frontend/dist, so it is built first
    cd "frontend" do
      system "npm", "run", "build"
    end
    # Homebrew updates kwnt, so this build never checks for new releases
    system "cargo", "install", *std_cargo_args(features: "no-update-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwnt --version")

    ENV["KWNT_DATA_DIR"] = (testpath/"data").to_s
    ENV["KWNT_LAYA_MANAGED"] = "0"
    assert_match "not created yet", shell_output("#{bin}/kwnt status")

    # The server only talks to this local port: no outbound requests, no API keys
    port = free_port
    base_url = "http://127.0.0.1:#{port}"
    with_test_process bin/"kwnt", "serve", "--host", "127.0.0.1", "--port", port.to_s, "--no-laya" do |pid|
      health = shell_output("curl -s --retry 30 --retry-delay 1 --retry-connrefused #{base_url}/api/health")
      assert_match '"app":"kwnt"', health
      assert_match version.to_s, health
      assert_match "<title>kwant bots", shell_output("curl -s #{base_url}/")
      assert_match '"supported":false', shell_output("curl -s #{base_url}/api/app/update")

      Process.kill("TERM", pid)
      Process.wait(pid)
      assert_predicate $CHILD_STATUS, :success?
    end
  end
end
