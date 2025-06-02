class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "b7add2bdd6cdce683eea5b24932ed12534b76c29143d8183216c4afc60beef04"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170ca77ac6679b9328df9d5da9a8d3227161031ff17feec521b271fad097ed43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44245c1005018aeefff4fe0885265e55ded796af87f194e04d359dad6fc3dad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "938eef3100512ec81969982800e41b84cb2efa2f4dfcf262c2ef67f146a77dfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68235503ed828ea8d81cd592700abb5e996fc6b24394583182dae26afc643d8"
    sha256 cellar: :any_skip_relocation, ventura:       "f33c771f11eebc356e0ad2415b690c2e22ce9540894813f4ed2c3d78d36a73cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419a7fff83bd072580ffd77de633dc95321f9346ff85f7c474f34d22acf15c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf0e61c3073f9afa2cb68f6e6f4e0a7de02c0142bc845a3e7ed509bacd34a10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pueue")

    generate_completions_from_executable(bin/"pueue", "completions")
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
