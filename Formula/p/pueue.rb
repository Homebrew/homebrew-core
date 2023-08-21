class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v3.2.0.tar.gz"
  sha256 "0c3126579661f894fb02a0d8c0e138ab23b277e97cea2d85e48d3d2b9fb1c372"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d612702eaf7cc670053c14af44e74ca539a94dbdef270baf7b28542666a8549d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cfffb4cf17d5617281a587028b66e405706f823a285de215065115d79b948cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26804d5d570fd4c44b7c998bca31596ea66a06395c3c36524e241d6d744765c1"
    sha256 cellar: :any_skip_relocation, ventura:        "cf1b43118a462384d3183faf04c6d36f83f672f4b976a28c1d77f69ce565df6e"
    sha256 cellar: :any_skip_relocation, monterey:       "2fdf39cab40d98865c4ae01985393f5107d784e87be606057ca1b4bc461150dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb9b4ffa5ac44581147f51586601cb1da7214c48cdbcd810b0973ee905d0cc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5385b14fb0da4505c8a30586b7171421c7949442b4043472cba5ab14c16f991f"
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
