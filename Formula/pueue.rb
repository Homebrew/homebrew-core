class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v1.0.1.tar.gz"
  sha256 "03f19e1c13ccd8ef4972ed3849df04741047f125302d66d92fa4f4a5ef669296"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5701a12dd6b1c7f80b4987c8bca1c06ae118b034258f0b64062f878809380bc2"
    sha256 cellar: :any_skip_relocation, big_sur:       "9dfcddb1449553353e059947ea4810304c61c07e710f2d106785fa0b3d0b17c4"
    sha256 cellar: :any_skip_relocation, catalina:      "bdc1926ca83547d7e59fadb230f9d0fb9de8a3ccb07def536e2690b25bb1148d"
    sha256 cellar: :any_skip_relocation, mojave:        "1e04b24afcb6f2a60c69f020d316bfa462d1ddf5a4d3032d1040993f7f486a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a69b8f999c152738ebe697d8cf0f2a67212a3db353ccdb6c2e665225caa5978d"
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
