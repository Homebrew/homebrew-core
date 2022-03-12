class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.0.1.tar.gz"
  sha256 "12d3ad21a50a8706ad79e05539afc78a877e64e273fc33a666a048d7a6fd068e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f634b3165840cae09e5c0f73745b7fef6bd7714e2806f92ca96c574fed5e825d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10fc45199878cbddd382905fd6d7c99c93bd76d68064f69bbedd666280fd3cf"
    sha256 cellar: :any_skip_relocation, monterey:       "963afb9ebd83d3d3f2d6266c6b82e0c78e1b83a28acf6fbf4c0fc7541562940f"
    sha256 cellar: :any_skip_relocation, big_sur:        "971132bf5e98c3c614b0ac8356540fc20f716f81a682021702f155825b73e4e6"
    sha256 cellar: :any_skip_relocation, catalina:       "4f60b8e5f942c7e105caa25db6e3507942c6d4f620f580d1e57ca45fff98f3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b7e5c93781431fadd1c6aa6b15a91459ac1b71d4b2e5537b1f955b5f56440a"
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
