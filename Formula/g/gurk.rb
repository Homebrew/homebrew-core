class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "08077c44f4cee3b5f2f31a0cc90d978e052a51677ed73af61419093ca154163f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f8677e9862814aefb81d13df70195b6c7968e8b0798a7d5890e748cfd93c702"
    sha256 cellar: :any,                 arm64_sequoia: "8e84a4a3ee7c669685f09e0197c119319995fc26fa30869097c2342088a5622b"
    sha256 cellar: :any,                 arm64_sonoma:  "3067ee9d06bcfe7f7a33ca4bebbb9f78c2ed76e7d6417edb9d7cb2604605fc5f"
    sha256 cellar: :any,                 sonoma:        "2284714d7d6bc0c1464236f086bb6391960a443cd23865ab37d796d925ac281f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c52b48a19871ae47fb2da507362cc82bad0521ee3cefcf82d49a3f8c6d4887a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9250243f80efd13a03c4f709ecaab1928dcfb19b28f77c6498034602a495ee"
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
