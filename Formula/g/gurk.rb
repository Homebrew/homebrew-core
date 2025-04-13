class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "e86e6e0938439ac84af5b1f08a99810f0e632c60c63ba58e566181ffd2578874"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0cc3cef149a12b05ca5b52ca1ea0d888b5f65dd083e4b315f4b3a5a77829a3b"
    sha256 cellar: :any,                 arm64_sonoma:  "8e156d730b5d988e6b33a2a783067c65010c2624eba23d7b3e28d3446300413f"
    sha256 cellar: :any,                 arm64_ventura: "fe8c8e3fbff8fa370e82484f882e8455c122d439bf2a81cd68cca44f822db364"
    sha256 cellar: :any,                 sonoma:        "7d6d5437c710ed6103022b2f61fdf0e88ee8096e206bd5d2e4411fe28fd50c26"
    sha256 cellar: :any,                 ventura:       "a91f26706d7f12cab12b4ca8c532cb49c5327cc63e7ba3929a10a4dc1fcfd93b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7285b0beae708e057aed8f506b9eef76657e7a8739e25c390e877dff026ea45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699e7f4e25955cd8a7613da7bf1f3b07d345672d3b2dac7f8d466fca61f8909c"
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
      assert_match "Please enter your display name", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
