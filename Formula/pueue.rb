class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v1.0.6.tar.gz"
  sha256 "e8df48831f4d9ae8fe5dc7a8428660b4c87c4fb3bf8d1ae620e030af74269ffa"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a09fd270a8a53b1655446af42cdc48e3c4c857178b61666aa6f91498837db96b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a739e0a7f078449351c03d43db141ef4467997dd3d4f88abe0097e4cce30f775"
    sha256 cellar: :any_skip_relocation, monterey:       "51b0cbfba941c44380d5f77907083116564bc51d6e18bff3dfa8fe29f01f9978"
    sha256 cellar: :any_skip_relocation, big_sur:        "f173437b8a8445b1af7497f34006ce5afcfa054420b8a9a6871b355db84cdfa5"
    sha256 cellar: :any_skip_relocation, catalina:       "98eb467afb7a87f10b3902287e7d0feba316505b8e9479c99df9a4974cdad975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7464ddc565805084113038adc09a0b7def5708264641d5f4c76104c91b2d3e93"
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
