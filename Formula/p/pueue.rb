class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "868710de128db49e0a0c4ddee127dfc0e19b20cbdfd4a9d53d5ed792c5538244"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069ad84e3ec9d9513ebfbe1272a18352cd6b0594ee9b3a03912b735a5bf97676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12dac34c9a768b35c11abd2e91798085c8af6dbe5957741ba2887a2435f2d2d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f66df95de1cdf2bef246ba8d327779dbeebd77314496c8a90be1c222a22ab72b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2cd03a375f5ee42700ba2698ba3a11fb453faebd7c9797b184229cb675dc37a"
    sha256 cellar: :any_skip_relocation, ventura:       "513cf264a536c71dac1211a840db4aaa18a45103d5486c523f3e42eeea4dbfa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b77846f503d5b2a7ae1262f26b11511b94f151498b103b0ed5aeb4045ad667"
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

    assert_match "pueued #{version}", shell_output("#{bin}/pueued --version")
    assert_match "pueue #{version}", shell_output("#{bin}/pueue --version")
  end
end
