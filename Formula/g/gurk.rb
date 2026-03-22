class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "7947407eb548bb660227eb03987f7214a48bc92ce48e65ff88cf89ac94461a34"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb13b0ce2df0b87689ce9eb1ef24d53c0f7afbd38ef9bbb18b2b8ac8667402a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6b5443f82ee030b60cfb7a7f1d16136aad597db7dae46de25419787eb4bfdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3724671b80098c974edd99588f92c4645c9d7157b49cfbd15d744ea0442cd1b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4920cf2ba637f27fd67a2a016847abc90ca000c9763ecb6514c392eb4589c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6f66cb0837deeef53c8f9cef6e93ecc90702512ee12dd65700e82f6e880b858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716705c2c7d0635637562df3b714a14a826ce71ec306d8e2d83d1d41b6aa3ea3"
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
