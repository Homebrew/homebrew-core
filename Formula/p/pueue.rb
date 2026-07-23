class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "236a47a1cc74721998f4de3eff5062efe8e73c56c05aa19e64fef2e5ee55700f"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d367b404f349334dbfe0e5aab8395787cdc5d4d37350694cb7123e05ef4e1a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd0ee212b361da811514fe5015720b2fd24fbcc91f6ad584c2848ae2ded4d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba10a95fae0c75f603200c8efcf5820da8aaf5092a17e02cd19f3107a76f7d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25d53eb6eb6c5308a3ca6a8869d3b2ebc3dd4cd2a1e5832db0a05b9ff4b8251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "735ff6f62896ab9cf12e72b11d46c17f5b8d6a221dc1273e3b0a5199c62d1740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba114cb8a262c8fc2673019d9c3ea66e4247181a425536d71a5b16f8288d8494"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pueue")

    generate_completions_from_executable(bin/"pueue", "completions")
  end

  service do
    run [opt_bin/"pueued", "--verbose"]
    keep_alive false
    working_dir var
    log_path var/"log/pueued.log"
    error_log_path var/"log/pueued.log"
  end

  test do
    pid = spawn bin/"pueued"
    begin
      sleep 2
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
      Process.wait(pid)
    end

    assert_match "pueued #{version}", shell_output("#{bin}/pueued --version")
    assert_match "pueue #{version}", shell_output("#{bin}/pueue --version")
  end
end
