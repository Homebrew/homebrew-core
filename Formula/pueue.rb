class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.0.2.tar.gz"
  sha256 "92e54105f840d973d048c280a9320c8740d205770d82f8ca882a4eb5716c4136"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82e255b96ab5bc48bc835de17a85a4d8f987546f25143d56289b3eef97c6d851"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a0f7bfa5914bc4086226b2dd7e92d0333cf7919bd847a88eebada5dfc0cc54c"
    sha256 cellar: :any_skip_relocation, monterey:       "9421f89d3476f3439eebb983ab2db424945ca4efaa5cabeedbd214fb9de257c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b79bb881c2c2edae1b2b12dad31b8425ed0731f8facccfa34959246d82b0ba0"
    sha256 cellar: :any_skip_relocation, catalina:       "5fa5ce0a03e4f00373faf52336ac6901c4546a1036080c6f77ddc980a88e9434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59ea2bfe560a2ddc1e87caf4c60f4a6999e46351fb8dc69c38c708865cbd462"
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
