class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "059ee9688cb8b1ce46284f5ad58de21911b6af50098d29598085d2b9dbd432ab"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd3cc2c551e3ada35ce6f835138fe512f64271640fb0c6147e0cd88a734f192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a35916296584183f4825f3e406b1c100b439b8ba1c9ef640c9b28b6d5a895146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52cdf7b5563f7aeff4ce6c755dde08edf718a9f152ff328deb5bf553dee9bd8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "109ba87c2e2e91321198f9e99915e947013158a2af8098d240973a247c5b66c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4a478c998e4a6f3d6664adc7c6e1631e9205c0f24b14c5f074d079a5d91418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9c2feea36abd35a6453c8f98741c318f4cac57810ae13746da76fbf5fdfc5a"
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
