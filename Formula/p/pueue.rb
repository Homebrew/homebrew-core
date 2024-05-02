class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "8468ff4d515d976607fc549c5eb994fa4f7d2ccdf47523561e34d778aa8d083e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df27a68fd9ead7d13cdf09b5907abe67f391bacef66285318d4099490ecbf3b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98fa155d4c6ba578067f34858932a6f680ff66ec5561a5e33672a574a141fc7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1adef705dbf0ef30c95a20a00863ab15e54e6bb8a6f758913955cf6eff43d1d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6a033cb72aae2d2b7dd7fc0317af769cfff458ff8ae1d19812265cfa887e90d"
    sha256 cellar: :any_skip_relocation, ventura:        "36bb63a58b5b52bf1bff0400290fe8c2a07571384c3f92e88c01ff363534b0d7"
    sha256 cellar: :any_skip_relocation, monterey:       "d8cf12ead3d0a17520156ffe26984488bdaff04deabb9575fa69012f9c941684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7962147fd3ea8482b095b20c0a68fe568a6fb24a0d9a073dd30709e7d20351e"
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
