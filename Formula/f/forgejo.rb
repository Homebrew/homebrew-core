class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v17.0.2/forgejo-src-17.0.2.tar.gz"
  sha256 "5b08f6c24819aeb62b80f2f50f989cfcdfde0a8887f66438cbf32b556b1b6efb"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "354dc0fa293e15a71dca25bfcb6d8fcbd4b5dbe26cecd214d3e4dc36d46b372a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "847a83896586d2a391e877b36fa659a9c6557f454891cc853dd3c3d2a3f68fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92626791cfefa2aa12200059559f56cf2e99c10d9d44625a9f516c0d4231a1dd"
    sha256 cellar: :any,                 arm64_linux:       "83a70b053cb56633be7cffc6a829c0497fa0742afa1123d755a3ff85bc304389"
    sha256 cellar: :any,                 x86_64_linux:      "2d475f7ff18ea5ed7b47b101b926623910925afeac2729d1f23b519fb45db49d"
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

    with_test_process(bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s) do
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
      assert_match "Go to default page", output

      output = shell_output("curl --silent http://localhost:#{port}/")
      assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

      assert_match version.to_s, shell_output("#{bin}/forgejo -v")
    end
  end
end
