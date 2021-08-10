class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.12.2.tar.gz"
  sha256 "3acd923759d5731b69a9a4a16c83c16a1f33589767da2ab7eb0cbe49ea06eabd"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4d2d1c08cf929b069e09aafc633f2d6190f9fc72db7af1a528849c3d96617dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "2602ff719f66993515cd06408672f4f91c5b79326635688af2f693592e7da447"
    sha256 cellar: :any_skip_relocation, catalina:      "509da33221a8f04f7bfd9c30dd92b3a1c33e5b28be5f7d8d548a8ce9eea14c5a"
    sha256 cellar: :any_skip_relocation, mojave:        "2813f83c83e78449efd26656232c4a1745f8f6bca2e97e8eb4e9c45c897747d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562509ca4c24f7838ddacc320018b634c7446a85259317a9417cc110549046f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"
    zsh_completion.install "utils/completions/_pueue" => "_pueue"

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
