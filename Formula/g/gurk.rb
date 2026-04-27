class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "5416fdf8042105480cf96abb9546d3094ffe2d57cfd2302eb6ba01422b398794"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca26745bf9377e95e4bff7dba359535a2e3c5a23c1953ab83cffe989430a7724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44369f0077a0606164a36c207298f984f50f2736e1183241cd96308645fff9d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7c2e5e498d5c3bbc39530351dcaccdb6fa4aaa10501cc7943690a7c76261b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3afcfb2a649060af84b01e87629a4fbbdbff213c2b319159ed0bcb1f8813cd08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4a6a053637a387aa41648576dcb4aaaa444edecfd1057f15fa9f3bcb098a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45de3f56addafe2a8a70a2ae46f38b371c41f3b934fed2fbc8ba5d872916324d"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
