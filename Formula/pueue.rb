class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v1.0.1.tar.gz"
  sha256 "03f19e1c13ccd8ef4972ed3849df04741047f125302d66d92fa4f4a5ef669296"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dea86eddf7b5b0084440c24c67ad521711ab25cf460ffa5a445799d8ffbfcf3"
    sha256 cellar: :any_skip_relocation, big_sur:       "49085ac5686357c70f74bdc89cbeddf8cecadbb2b936d578a557044db24d6d05"
    sha256 cellar: :any_skip_relocation, catalina:      "9d09d556e85b45bb32dab174bcb89f5c1dcd36fd4db386f3657c37d5a7e99b4a"
    sha256 cellar: :any_skip_relocation, mojave:        "5dc2b35000df32fdff268d99e17d9e0ae987b5d2e7d18b72d3f3999e4a1dc5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7803f042c0efa3bd1a255c21fbfe34ae22215c0406f7d2a760a3a26bf4a4e3c2"
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
