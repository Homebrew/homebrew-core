class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.3/forgejo-src-16.0.3.tar.gz"
  sha256 "169df80055a819e3062eab365c384470ad34f71a0b921a58c3dcd1f838c10864"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f52ddf234221723780afc9ecfbf78fee2329bcd3739a1e4de34134f3c6155300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae238386991a96777e991ed3e2c5691046b789e52ab510b28ccca920ffb9ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fcc713b24ee3345b02347210cb8ad4732666f6c517b31226b8bd1473467838f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b214434b46ce18259369ffc8fbd65762cc29ff1e08567d965b251f1cb53f9be"
    sha256 cellar: :any,                 arm64_linux:   "e917f8a91f0d754b49c7f9a5eac49fabb7c4e4c753a87f6bfd90139f08746fb9"
    sha256 cellar: :any,                 x86_64_linux:  "dba6378fdd65c06e39147296e2d7980a3bc90b9601c399267b79c990ee64d174"
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
