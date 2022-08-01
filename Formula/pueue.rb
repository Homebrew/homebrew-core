class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.1.0.tar.gz"
  sha256 "cd5c6500e65960f6a102db5d0f0544f49eec8f74b2cc0df16ded8e2525a545f6"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c29548258ce75deb56323a25171c19fc8b65c59b3528c01cf54795e0eb599e4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae3c5df9f8e5806b6491ffcd961e5b82e0ce0e1388d716a310b60e0a0830b2be"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a3476363b71812a96b2979534efcd5d2805499dac71f9282377812a18d1ad4"
    sha256 cellar: :any_skip_relocation, big_sur:        "69320b094180e687430f5c804ad24e5bf1fe7d43e5e53459f47849e959d26da6"
    sha256 cellar: :any_skip_relocation, catalina:       "5c6d4bef8102f8c314a7daa0098d6493631881d21edcfb48c1fabc16afd5beeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86dcb78f19ae14358dae333087e1d54d1468280cacd2202baccda1da43174bf"
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
