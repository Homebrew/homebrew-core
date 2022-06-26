class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.0.4.tar.gz"
  sha256 "45b8499b062cf83ce9a2fa79c9d6f2611ae676e72ba4815cea2b56e294f790d1"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebd1bd6c766df8a08033de812b6ea2172e94c55b3a13562c3c4322c1cd2469ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4772f97a43c79827b79ae8e6585c761b89274fb235352cf28bcf2a9ea422543c"
    sha256 cellar: :any_skip_relocation, monterey:       "e78b4798bfa66fe1a3ca7cafd8be3916ca781d6028d28568544167ee7d94e287"
    sha256 cellar: :any_skip_relocation, big_sur:        "eec7e5c8c5af60a0c22bf743c3087256e6613c262658d7f44896e48f4bae9aa8"
    sha256 cellar: :any_skip_relocation, catalina:       "09ae517ea6781c954601bd1f4f4a2afb19b66d66d99a51e6cdb83e4dbe872ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba3f7625a6e42b7a94f787f889ffea9fe71aed196c6c7339774fa8fcf5bf842"
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
