class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v17.0.0/forgejo-src-17.0.0.tar.gz"
  sha256 "e89c58b872b05b451b630a7ae55a35e79c42cbdfdfd091376e06754ca203526d"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d997331b207cf62e274ab7d15cf668c242152d1146292491360f8053f48238f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74b8d90af2b4c1045b9adc0ee3d294c85ab034b21b65a89510852f8e68aad66f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b023e2d5ef539ca352600521224a3dd579d18abca52f642473c84e596651ea5"
    sha256 cellar: :any,                 arm64_linux:       "24f1b887d8c1683ba56b753c5ceb4834a66b0a5791442fb6916b07757aae5c34"
    sha256 cellar: :any,                 x86_64_linux:      "e55022a8f94203cede03c2cb0f6c312b364dd98a9253eaa72d2aee930047fc78"
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
