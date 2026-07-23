class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.1/forgejo-src-16.0.1.tar.gz"
  sha256 "3699caf038f097cf01c1633d64df966e27916bcb5c46fcd0a5130c9debb858b2"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "528e71394ff6948fa9f12de6970480497cad23237a8926104a051b555821b930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ab6fcf77ef4fcbd3618578af674110611b4d9cfb8bc89a8727dc7660352a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eece1938aa2a894e7590cb57436c15a876be5bb63d3abc0834872e64704a1170"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fc5793a28ac4943bb52f0b58af5c27b01a92a453e512bad1106247a943b99e"
    sha256 cellar: :any,                 arm64_linux:   "c35d7fabec7a6052553fc9d5759dd10d5c46878330ed0ad245e07ef3b2026b94"
    sha256 cellar: :any,                 x86_64_linux:  "2f6738dbe67549774239192b3714701fdd85b15454ee98cccd0dee6000764540"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"

    generate_completions_from_executable(bin/"forgejo", "completion")
    # powershell completion uses "pwsh" as the shell name
    # instead of the usual "powershell" used by generate_completions_from_executable
    (pwsh_completion/"forgejo").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"forgejo",
                                                            "completion", "pwsh")
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

    pid = spawn bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl --silent http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
