class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c6e972ae1c40ebc0cc245dd88b3dbbfb0e8afe5bc2cfcb7c7318790a1cc7038f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a005a3c784bc139530adfefe80e95ebd40baa8b032017977d38070c1b68e965"
    sha256 cellar: :any,                 arm64_sonoma:  "fb6281de5891599c43576708a0a869633abb44f7c017a95035e78bddf434dcd2"
    sha256 cellar: :any,                 arm64_ventura: "cd00cb621aa0c2c4b7fc31b2feabfb14e64f968928cf781ec8bd28a4493eca1d"
    sha256 cellar: :any,                 sonoma:        "97a5941cc2d2aa9b7b41955c64f3799f45663b60c69b0c4178223d224c4366e2"
    sha256 cellar: :any,                 ventura:       "e17eb5c000f30fda004ddb969971e711ae18e8b3faddd1ac0a36e0265121a028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687a15a8f606810cc9be0c62d2611cb60936457242da3670ed91625f0d82b5b0"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gurk --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"gurk", "--relink", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Linking new device with device name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
