class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v1.0.4.tar.gz"
  sha256 "c4ddb496f86ab4c10b322d5a64be4f96f6c8779796983f4500fe341300b65072"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a92df8647f7ed6882057cb2592aad3d37614991bd78a007dd5390946c48284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9b5b7101590b35413c467ac6b03ed86b256cdbc2832bb2c1c6267c4f168e07b"
    sha256 cellar: :any_skip_relocation, monterey:       "9f3f898387ad0cccb2d6a2471707df0f3b53b3a8b13b3773b8d26b1904210159"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8e111554e48180b9b0ee4d385079fbb6618c9e892441f7056bb7795cff89bd"
    sha256 cellar: :any_skip_relocation, catalina:       "bed9af0542c44eebb6ab281a3e8022f7e0b5fc6d6fc47006ef8c83db66f47f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5e77735cd4e91f30a2c1836edf6494237e2edd189698736a6d5702554ccfcd"
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
