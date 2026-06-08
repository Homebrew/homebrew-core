class Gurk < Formula
  desc "Signal Messenger client for terminal"
  homepage "https://github.com/boxdot/gurk-rs"
  url "https://github.com/boxdot/gurk-rs/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "1c8ee4466374375a3df2ccd94fcc86d76bfcdd868820f3f9d4a1f2cbed2be22b"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d51e753ce3f279e3d9dfdfd60deced869c996e8fdc29ec7e6bb769d6e4680d30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b88b0600de65cf507801dd6ec8e4492c12f72bd2c2a90fe787be30672cb681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b197dc77ec944a137ec15d2d23e156c83b5a2367ca08adf94a2054ce37dd33b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa085cf56a4c1e466e3a17f3d51e788ffccaa7db738d98ebcaa59f689830f20c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b0aa9ba5d6820e76156328750d5e571d9c82f5af17886b4eabe4ab07eeda9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2cd983ea34ac4c5d7f1ec14e75e12f95426bc1c1e0c4077d05a9226ead44789"
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
