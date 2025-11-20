class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "7bbe552700041b2e9cd360b69c328d6932ad57d0e0a480a8992fab3a2737cdf8"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f7a90e264ff587c6aea3a2b9d22ab299f01ffff21ab57555a1e2dc3f1d7381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7401d5fd541b7434ad9e32192bb87aca9005264e74221425af579029a03d273a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc6759a32036c73c595b374d27a5bfbe9a90c8686510ae1d214547a2e02d894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "111eacd663ec1d99e4e38a853cfd827f357c73d41052f245afad6d00cb174f5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "da6ac299cb09ad63c0ad7a47a5ebb4e2522975f7df67d5ab54e619205102934b"
    sha256 cellar: :any_skip_relocation, ventura:       "49f5765541590b87a5cd4ae3333e6c6259b3b9dada68e31b3adc9b196b83d97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7f16f36d9aa5b2a6935d725fa83bfddd77be23e4a37812b93f6c725afdfdb7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87cd64ee72fd805188640798966bfb0cf81d8891d35ab81c14ad839013245cbc"
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
