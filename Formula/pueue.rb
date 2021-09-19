class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v1.0.3.tar.gz"
  sha256 "eb20da7425fab406ea33322aa6b248c350eca631b8e23f2fc2ee80c1505e439e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7692235fe220741fc6115a693800efd25baa1f4d250a96f619ff9f0ef599c27e"
    sha256 cellar: :any_skip_relocation, big_sur:       "498485e3aa3ff6562d4f79509426e744d4061cc8b5f936838a17a4c99b2ac350"
    sha256 cellar: :any_skip_relocation, catalina:      "43ad1d2ee2c78e402b1fcdb8e94dd49eab29d30b7fa31f704ab046394938ad88"
    sha256 cellar: :any_skip_relocation, mojave:        "28ff30dd5c01a9acbc060cc544ca35b73e7cabb4428723022ff78ffba02197a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae3d2c4545c4121faa1e7c9bc194d6b2aacea045751095cdd487ab6b9f8f0f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"
    zsh_completion.install "utils/completions/_pueue" => "_pueue"

    prefix.install_metafiles
  end

  service do
    run [opt_bin/"pueued", "--verbose"]
    keep_alive false
    working_dir var
    log_path var/"log/pueued.log"
    error_log_path var/"log/pueued.log"
  end

  test do
    pid = fork do
      exec bin/"pueued"
    end
    sleep 2

    begin
      mkdir testpath/"Library/Preferences" # For macOS
      mkdir testpath/".config" # For Linux

      output = shell_output("#{bin}/pueue status")
      assert_match "Task list is empty. Add tasks with `pueue add -- [cmd]`", output

      output = shell_output("#{bin}/pueue add x")
      assert_match "New task added (id 0).", output

      output = shell_output("#{bin}/pueue status")
      assert_match "(1 parallel): running", output
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Pueue daemon #{version}", shell_output("#{bin}/pueued --version")
    assert_match "Pueue client #{version}", shell_output("#{bin}/pueue --version")
  end
end
