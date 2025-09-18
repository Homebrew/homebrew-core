class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v12.0.3/forgejo-src-12.0.3.tar.gz"
  sha256 "65318cf8c843d92ee984f26072846df97a76f2c7f5dcb76746161c7d21b70974"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98aa2e0d4f2d111cb097cfe94fff00b90100899894c948306073cc8fb574b91b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2218ce6f718ce4be76a7655cbea06606a93e289af210537fcad65d434d8393e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6e531c8372bd283477fa44519e74ab614a42f839b810e99eb6fb357d78e15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f0d994c0f30c871869848032895949efb25446d6ebf2a841d730bc1ff1d6037"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d29e02d5f299616d59b7eff0219c64ddcb66de99cd1b31f0be5a1f2b031fb1"
    sha256 cellar: :any_skip_relocation, ventura:       "b0c623e840080c3c69b0fb0a6ca195fcb49a5bfbf903d886bd8f211b8b3d68a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c917b7a85a84383c20cc11375c912aa98598bb269c65e805e2e3f14431b900fd"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"
  end

  service do
    run [opt_bin/"forgejo", "web", "--work-path", var/"forgejo"]
    keep_alive true
    log_path var/"log/forgejo.log"
    error_log_path var/"log/forgejo.log"
  end

  test do
    ENV["FORGEJO_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
