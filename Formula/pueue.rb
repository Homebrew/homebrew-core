class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v1.0.6.tar.gz"
  sha256 "e8df48831f4d9ae8fe5dc7a8428660b4c87c4fb3bf8d1ae620e030af74269ffa"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfd4a5d0a072cc85246acedc91600ce1d5eb670d4ff5243408f69a3a83ed1c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d9e8dd929afe0a13730765e52199560349f8f1f01c6613f017ceeab8b16c3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "73e39af0dbcdfb5face990bd1309c074ac8719c0383bb3cf214e1f13cbbd075d"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c7d1a434f78296941814d4a39baf32745a99e2598a73bb744e53dda89abba6"
    sha256 cellar: :any_skip_relocation, catalina:       "75daadf699119214dea6fcf4c3a04a7537d0349f80b3bdbe79ea58e0990f8aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b6bc5c52a355f1c20806afece91d702fcad3385b97c6f80c09420d4ae8dfbf1"
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
