class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.0.2.tar.gz"
  sha256 "92e54105f840d973d048c280a9320c8740d205770d82f8ca882a4eb5716c4136"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60da7272b878cea08e0fce5837f352e6f67402dba30fa1d72fae628d8db0d7cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71441f15db84eb6d278b19d49d30358ad653ab46c2b2b87856e1014438b62b30"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0b8cc6b6b1c6f4286f2e6a89be64ea01aae2dca4d37815751cad24c74cf944"
    sha256 cellar: :any_skip_relocation, big_sur:        "593066d61dc94fcf72eb720d4444f6bf1917ed877de04b98f476588548671952"
    sha256 cellar: :any_skip_relocation, catalina:       "1e2c08fe197b1fc446f4aa3d69a6885b9b3b428174abdb0ec8d588b9b9974ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40ed92a9b201f707e12a3f225698df8d0ff6b41025d65b0af261493b1bd97e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

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
