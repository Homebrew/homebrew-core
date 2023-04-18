class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v3.1.2.tar.gz"
  sha256 "653eac9b7fc111cc4b9bddacbbf514932a8d273a059b20b1cc66af74e500eb5e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b146c279514a18330872212302d773470987a00383dd7239cf60f750c9bd157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2331274bfefbfcaf6dbd3af496190c8786cea160a45bb0ec5edfb737fe19a48b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b081160d0afec619c665538b6346025f81871bbff8e8061e74a1a5e68de5f60a"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0ba43fe613ce279cd8ae1e729b97b6593be82027b5d1d9f9a4e702edaeef14"
    sha256 cellar: :any_skip_relocation, monterey:       "424dd3a80516e6f4677570b123f1ff75d3cd0761475417b954e28969c0a79db2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d3b7bb8ef35e559eff43ba45ca77e6aa2239b434200dfd94680e8be6c48c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc8f5696d76226da75ba317edbfa7d3aef1aac9d1c3f33eab6d06ce95a13cd0"
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
