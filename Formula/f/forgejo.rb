class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v17.0.1/forgejo-src-17.0.1.tar.gz"
  sha256 "d6b32ac77e71af0737f30613d985a0dc335b694b8b989d609a0cc88972f2fd4d"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02658fb060e9d2ec63dee4b280aa45da95f8b9d2baa860c0f3066608ead2b800"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b33f6226455e54c1092dee16306f301c7d9893f88a1c57c3be7f38797effaadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19db7c548064dfd4097264a7b4c4cf3b228bfd6190bc33a3c6e8a9b26c3d0e06"
    sha256 cellar: :any,                 arm64_linux:       "283fd314e41dfa09b127f0198ca8499042ba26e3049649b2b601bf0af26c9891"
    sha256 cellar: :any,                 x86_64_linux:      "26eeaa42d685504ee72f00a885368b690230c3e89fe70d7b8db034e6d6f6afab"
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
