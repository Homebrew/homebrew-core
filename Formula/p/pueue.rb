class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "8468ff4d515d976607fc549c5eb994fa4f7d2ccdf47523561e34d778aa8d083e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cb39cb3d9dda709496273d906ade4c862d57f5e55c42a4b5cb2b68dbb49245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0c98a1f0576f34f34200d887a1270bd4d45eee9a2e630462d6d4b3a60f65c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44dad088e1653b4709352090b8e2e531398a4af4ce9c218b71e6f80be5ebbf44"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0a04b3c9503876970d343472f8321d757db8696e2b9d0d155a6ef961acee5e4"
    sha256 cellar: :any_skip_relocation, ventura:        "5eabed693b44c99b08ab5033993f94c58436b61bed851261aba4831d26227dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "5c3e2c327b667ffe382dab19f4323710310bc885366f52efc816655f0daa663e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e2908e5d0888f8a2928ecae98dbc6dda5bf7f6969247f49f8166b911e242d6"
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

    assert_match "pueued #{version}", shell_output("#{bin}/pueued --version")
    assert_match "pueue #{version}", shell_output("#{bin}/pueue --version")
  end
end
