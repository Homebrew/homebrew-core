class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.1.0.tar.gz"
  sha256 "cd5c6500e65960f6a102db5d0f0544f49eec8f74b2cc0df16ded8e2525a545f6"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b89a6d7270ae8ee9fff49df5393fe075c5e90cb837fd6ea9c81ffaa278608239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d05b6ad0ef3f6b27da90976eb1bc948a195530ccb6771a694924e867bf44b51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a1fe0d00fb4bf469f9faac604139dfae3ef18bd757c77b08091eebe8d3a6485"
    sha256 cellar: :any_skip_relocation, ventura:        "a73f5d927872a143b34611f0e4e65d22af1dcff2f6a4754cef4fb50efbbf69d1"
    sha256 cellar: :any_skip_relocation, monterey:       "4108066efa003231066a774e4e3afd6cc82c77b1b2842c6b50bc7af21d9b3ba5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ccc11d1d08f6dacc4182195e414faa3b31cbbcff90ff2382e4267b4a42acca3"
    sha256 cellar: :any_skip_relocation, catalina:       "bfe21ad662f8137d5f4ae9bbbbb940d8a28963a5d8b25342f6251195a11faddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53af6fe78a68e52c448d668029b616ef0bd00d1bad5519218e54b946e426bd43"
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
