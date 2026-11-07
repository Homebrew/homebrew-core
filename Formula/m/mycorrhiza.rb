class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "1724c0439a6d0174841cb777a13ab82b189c3e3a855f858cd24a62a8620a1e2f"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "651de1cd0bee6f9dd60f3f935a7fe2801cb93b859c2a11bac899d8bfa7587f1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3f2450c52ec03645383ccd46e7c1f2e75685900c15832bd7452528f9bc58fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a3099d3864ad9a4fd5040ba3a5b4a78eaaffc9a851f4b8f2e2593295a3f994f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c4afc1d2eca17e3bc6f446f817a770471843bd17a5e798b4741096319d7bfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0e6f72654ab0e9482291f0c8f221f40a15d997f581ae3d77d6152048f6c02d39"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
    port = free_port
    pid = spawn bin/"mycorrhiza", "-listen-addr", "127.0.0.1:#{port}", "."
    sleep 5

    # Create a hypha
    cmd = "curl -siF'text=This is a test hypha.' 127.0.0.1:#{port}/upload-text/test_hypha"
    assert_match "303 See Other", shell_output(cmd)

    # Verify that it got created
    cmd = "curl -s 127.0.0.1:#{port}/hypha/test_hypha"
    assert_match "This is a test hypha.", shell_output(cmd)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
