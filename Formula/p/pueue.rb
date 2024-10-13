class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "868710de128db49e0a0c4ddee127dfc0e19b20cbdfd4a9d53d5ed792c5538244"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb6f6bff43b00d41920ab98ee941fd5a275cdc885b48e1e15a72f51fe4bf56c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08b84e59e008d5991d5130b37a3e14522d9e62bbee1700303ec04a9680420582"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbecc5333cee858957a8aa932d13274d1b47273abc84e361238bb03109b366b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2d616bd61a583dff5ce25d7a989913f12d52fe1d425a25c8e7b6597c18ae05"
    sha256 cellar: :any_skip_relocation, sonoma:         "da97ac900e9fcd34c2f268e15b94dde63632efabae09bd10d5cc4eb1f930b3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "8c38cdb41fd486c9c5fb95084999b736184a82f06db7f672bdb8f527138ff04a"
    sha256 cellar: :any_skip_relocation, monterey:       "57440207f7d1f19ad572a256df80eef88e4db9f17ab22a6b30cdc1683b0dc3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27022107ac3e5b7af30bf1af50a811553b44689d4fbb9c9225a43afae5b9af8f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pueue")

    mkdir "utils/completions" do
      system bin/"pueue", "completions", "bash", "."
      bash_completion.install "pueue.bash" => "pueue"
      system bin/"pueue", "completions", "fish", "."
      fish_completion.install "pueue.fish" => "pueue.fish"
      system bin/"pueue", "completions", "zsh", "."
      zsh_completion.install "_pueue" => "_pueue"
    end
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
