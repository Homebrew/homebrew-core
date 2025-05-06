class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "406c27bf296c2ae4b9e03e7b7bb9f97203dd190142d4464f4111520501184abb"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc64931bf0700930970aa81cd56a06b45213f2e63888dd5447437763b2fb337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b4e7e7f5db3a14badafb6a43fdf8b65310ab04669983ffbda09ae47e5c265bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90ed86128458b4a86b1f352a8f176f23c7f6b92d5f9d85417432cfffe33292a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea3c829160d2e9b9887fb76e696191fe7146e10c112fe4b32ebce5dd80217a8"
    sha256 cellar: :any_skip_relocation, ventura:       "d4605cab2c794f5bc22a073346e50160942234ec558f1b36271e12847105c595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9486cadac4b4f41c7a22491771fa0e5339547ff9bc7631df9570f52a3d94337"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin/"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}/kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http://localhost:#{port} > /dev/null 2>&1"
    sleep 2

    output = read.gets
    assert_match "No previous state to restore", output
    output = read.gets
    assert_match "Server started", output
    output = read.gets
    assert_match "user_agent\":\"HOMEBREW", output
  ensure
    Process.kill("HUP", pid)
  end
end
