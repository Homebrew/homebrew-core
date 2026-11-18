class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "1df97d8253ced4b987adc1f9dcbedb03153380cd8d04eb92f6a76d9340a5cd99"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b37bbaad431b3349abb6b27bfbcf26e634425949c472ccddf67d30dc63c114c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b55ac7e5eca5131d0345cd70c6a42cadcb36f336fa6b7ddbb21eb6301f9da4b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4a775e37b5f599224adc910daa597381b1e4f6a53ad8b5b5f11415d211a3abb"
    sha256 cellar: :any,                 arm64_linux:       "266af070a031c7a088b9c6712a57a3c1b161631fd7c711dd0d0b7dbc1830dc9a"
    sha256 cellar: :any,                 x86_64_linux:      "2951ca326dc3fcc0ec0f4556e84a670fdf397742f46798b34a8971ddf28daddf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
