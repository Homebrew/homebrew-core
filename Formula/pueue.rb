class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v3.1.2.tar.gz"
  sha256 "653eac9b7fc111cc4b9bddacbbf514932a8d273a059b20b1cc66af74e500eb5e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "740004a6b0ba740141cb60679eb74ca4cf4b028d4868e489ae96269f2ec5a20e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad536e9e23b1c5aadbc486325f5847fbe5a7d2a4d2f7670380731671e68674e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b281fdbd8a7ac36c9dbd548d76a766bd8a3e273129ae2a034ab228857c1cd5"
    sha256 cellar: :any_skip_relocation, ventura:        "6c3beb3f6a58a56dfb15d60ef2bef08ffac76f0dbe588078d130c1b1a067c41c"
    sha256 cellar: :any_skip_relocation, monterey:       "aa8bd21ed78a7ca4107741824b32e310c8b1c745196e71c063abd2cdd7a228ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a9d3f15c50c6ec2fe60807a1f45287f36aadff151de5f87b095b36c1b52ae0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90d1645ffd8f341a65dc523f8fb925f776f94b0115f0f7b5763c8a3ce813b37b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pueue")

    mkdir "utils/completions" do
      system "#{bin}/pueue", "completions", "bash", "."
      bash_completion.install "pueue.bash" => "pueue"
      system "#{bin}/pueue", "completions", "fish", "."
      fish_completion.install "pueue.fish" => "pueue.fish"
      system "#{bin}/pueue", "completions", "zsh", "."
      zsh_completion.install "_pueue" => "_pueue"
    end

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
