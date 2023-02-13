class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v3.1.1.tar.gz"
  sha256 "21595455d63f8f7d8944813da4837ff5ed7bd4e85c65b9cd56592f601b9b3459"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca3f094af96f4fd05055b9354f89cb75e962a1c2b0ef0190d95f56396b3a6f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a20e61609e9ad9fc61f37cecba5db161b2ce866c175a394efb293118bffa4c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fb425ba5807f8ad6712f677c7dae5a893bd32d24980574416b43f24865bfd32"
    sha256 cellar: :any_skip_relocation, ventura:        "3c043589cf0da921653eb8fb50a3d6a38b2c2edcabf825c5cfacc24732d79ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "326c900e023523948d38c09f2d914894a5e1c056d11a9380ca9858fd5025835a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dd34ebec8406b77bb85babf3155b695160d1775d5fc097f566f81f1d3b68bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f1c3479a5a30fa23a65be72cf2d6f0eb56fa18e26daa763a6e9b4e8a5db15bf"
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
