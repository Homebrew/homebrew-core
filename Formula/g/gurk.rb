class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "8db5a45dfc1502be589d5ea633320cec94dcbbd4b38f489404b784d4b4aa702e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a011fd07aab2f2e57a2c28a5e110b71666e719252f2be4b55b889804f9f198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2cdc07a3d9f40eda618bd06b0f242cf6b90b110a44beb3d377636273d2ac1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd80892945e69d9154db347e9652e4c48dab286a488b4c64a0e52f069f3021a"
    sha256 cellar: :any_skip_relocation, sonoma:        "291ccb4ce58e50cef75898269d9a1bdada0651251b57e42e52a86982bf309966"
    sha256 cellar: :any,                 arm64_linux:   "38b7e6550d7966e8c8bcf29430aa371d8863ca9608e72ef43a8715d8341fa9a5"
    sha256 cellar: :any,                 x86_64_linux:  "183d50f36541a982cc1cb7ebc0ed6d43936f6a1c8a04fe4a94bca7f611c382e7"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
