class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v13.0.2/forgejo-src-13.0.2.tar.gz"
  sha256 "6731d5e73a025c1a04aba0f84caf80886d5be0031f4c154ac63026e7fe30918a"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09e32a517734fd3ae2a0d171eb4be65601071cdfc0e3782b0bef004a0e015ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29564520fb7360804c623954dd6522a0a00742b603af407ff0c3c34b15c45f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b96c0969e3ee515720cd66c998828b6dcb4e9b2b343e791079b8ca5e68acb92b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a293d1c069c5036c324ed66e97cea1802c333b5f6fb347b84c3b21671cda583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692e77fc8f9039e83d655d9cb619337723319747043919772c11051f02731699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9dcbac2b4ea3ac8a01ed80839db3dcaccd1847a15d6f8b04e5db1edf24607c"
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
