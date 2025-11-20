class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "a0dde8824e433115234849ddaa6771b14356c6a5c3493f4134fcc146bb3fa984"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2df3f787af01096792321b5731046cac78519c9675697d882dc82ac4d924248f"
    sha256 cellar: :any,                 arm64_sequoia: "80b8de7c3a3916316134d7b4292d87a601bbb4d8cf092126c698cecac1c2d7ee"
    sha256 cellar: :any,                 arm64_sonoma:  "288c0299cf7af948d39aa310a0f57074052dc215af0fb7dabf0ea2c2315f6542"
    sha256 cellar: :any,                 sonoma:        "0ec755f70db248e0545456f7b56dbcc231f0934dec460743f09d222cfa5f4687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8672a9d93ca7b6c0f26e7a2d0b1c2519b6fc6bbe0000ade49087a8665d8b1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c37f2fcb023044ad2aca0fdb62d8096ad6051eff00532e43e1f5937e2ba0f75"
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
