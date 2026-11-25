class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "c57e44bd6a2fe679fa1d3dcdb6b8889b6a32cc7bd534607c62b6c253917e2226"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    manifest_sha256 "905363550ef8c4e73f4c9c58170e2ea8b5ae623db50dfcb9594f9aa07efdf1e2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4793a43336385ab17b3e57356198492541d267afeab9effa897591055da25ad7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "305b4bcf27284fa0e77456a114983758ae166bd08c189ab653dd9acec4fdf6e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b21a786e23b479f2aa495edcedb45dba1e23ad103d7d6af07aabb904bfa6159a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2fa889de4de4615915c05070519c0f10e600bd1bb1248e01177c625c15d846a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cac0f2790800515bad7dd9238c182cead2c4f1fcda1cc12b8bed884358b32aec"
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
    with_test_process(bin/"mycorrhiza", "-listen-addr", "127.0.0.1:#{port}", ".") do
      sleep 5

      # Create a hypha
      cmd = "curl -siF'text=This is a test hypha.' 127.0.0.1:#{port}/upload-text/test_hypha"
      assert_match "303 See Other", shell_output(cmd)

      # Verify that it got created
      cmd = "curl -s 127.0.0.1:#{port}/hypha/test_hypha"
      assert_match "This is a test hypha.", shell_output(cmd)
    end
  end
end
