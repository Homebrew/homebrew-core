class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v3.0.1.tar.gz"
  sha256 "f70e0fb4b3ea20a910615bb1ef4fe8b63b13d39105d7136f83c47db9c97541e5"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74ff728de0453c5d823907228937787c94df9f07d1e6c677aaae4b8306118a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56240b98dfdcdef6d633353a75cff506030637c9da3b972524ba31d2087220d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f646c1873efcd1dd974f6d1dbf6e0515436af885f0e25c184a219fd1ba39b17f"
    sha256 cellar: :any_skip_relocation, ventura:        "20bb0f582a85449a4e07b77893098b29e60a62581719ee06b05cbc2e548fa271"
    sha256 cellar: :any_skip_relocation, monterey:       "9f2e5ea439fea856b1488beb9815b3680ac275acaa4927282bbd28d61f95e3c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "10a20283285e381eb36a813775edcdf1c78544408a87ccca06d2671b2f96c577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccafbf41d8fa6ffa9275d9123f104d4e224d5492c74a18fd48625b47050dcb28"
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
