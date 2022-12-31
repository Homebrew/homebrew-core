class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v3.0.1.tar.gz"
  sha256 "f70e0fb4b3ea20a910615bb1ef4fe8b63b13d39105d7136f83c47db9c97541e5"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a855524715258f855bf54be658b55449aa392d24ce8c8a35c4431c2e9113106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be9925d3965a43478e5e94275da5f857ebf833c038fd2336657a0dec49d57a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a3658cd6ed0498fabc7dd857e9075f78228ddd912a162d0cecf5d5f217c2d01"
    sha256 cellar: :any_skip_relocation, ventura:        "410a3883e16910e90157ef4e9125a1750ff099691629248190a33bf847084e09"
    sha256 cellar: :any_skip_relocation, monterey:       "6ed734b430cb6c95e6a24e7d65ce16d4a9062883e271f564c2ba6267ce1767b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3da36a9e66c804b6452fcfb9d2ab5e0b0221e9aefa2cb24476ce63b4aa28182c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6aa60d04e3f86633fcc01c8920aa234d3bd3618c0c662bc665f3623fbdff63"
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
