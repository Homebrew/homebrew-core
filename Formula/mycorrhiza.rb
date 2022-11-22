class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "f2b4d2f9ccb610b73b854580a7147706481247f62a6e11ab8e1a488fed2162c1"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50bfa59b8aa982aff43a1c00eca109da5b86504f84b7faf35eaea22bb32188a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd52032b2851d3e9559ca4a3468547f3707788a5e83a0297be42e3691a272723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d76f4f141b6a275a4770992cda4c691168154d56efb9379dc7a91353f4b54271"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd5566d4655d980217061919491edc0dfe894c6cab74f874a88c884b37732d8"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7755dd442a050781cf8ede035969b303bd7f9c12c19e713e3bf8a625de0073"
    sha256 cellar: :any_skip_relocation, big_sur:        "1898fbba1e922a85c0037cb03d50daac27a3169748b67c66c076e3e08e0a42d9"
    sha256 cellar: :any_skip_relocation, catalina:       "7658845872ea924c08a3a7c03bd26e54893f12b4755b07c52f30626e9d0140ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7499f837d94adf4d92b40d8b83c6fe3db2c7692a5c630862159f061b09fb4ed0"
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
