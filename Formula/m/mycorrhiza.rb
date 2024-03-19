class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "6448fe7fa6198cb3346f63d0857d5f364d0aa8fafbdc95f56ef39fbe774bbabc"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da8c5cd19c7f4ac6b9cb115d44df9d2fe9a4142a56346b45aa917198fa4607c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a764a6c7bedfe24668b9e58f06038971b3894eacf65cc9957984b3de68d0bfeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "146772e8ec9484112fddc8f855259d8eda45de1aa1bad71350668e1e2cfcf221"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc21b6672244098dc8dfb6ccde5d40193c1b2deb7903c27e040c58f0b9386c36"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c7dcdce685c91264e08f10db3455c0d6469d157a205571a16eceb2c311e72bf"
    sha256 cellar: :any_skip_relocation, ventura:        "a2d9ea795d54f472db53b27195f85ecf14ed542876b1bb165c546d256011f5d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9b6a1d405d5e20e68ceefc6c04105853e10ea7dd1fc1262edd2a72787f471eb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b094f251e1568925e66101c9769accdc26c92aacc9b3b4aac86f60568b4130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ae4bcb8b6bdf669d6d5ed49727759bd104e4156c8d60a9dd20a1b996ef4966"
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"mycorrhiza", var/"lib/mycorrhiza"]
    keep_alive true
    log_path var/"log/mycorrhiza.log"
    error_log_path var/"log/mycorrhiza.log"
  end

  test do
    # Find an available port
    port = free_port

    pid = fork do
      exec bin/"mycorrhiza", "-listen-addr", "127.0.0.1:#{port}", "."
    end

    # Wait for Mycorrhiza to start up
    sleep 5

    # Create a hypha
    cmd = "curl -siF'text=This is a test hypha.' 127.0.0.1:#{port}/upload-text/test_hypha"
    assert_match(/303 See Other/, shell_output(cmd))

    # Verify that it got created
    cmd = "curl -s 127.0.0.1:#{port}/hypha/test_hypha"
    assert_match(/This is a test hypha\./, shell_output(cmd))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
