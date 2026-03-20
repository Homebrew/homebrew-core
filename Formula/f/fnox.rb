class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "c22ff2d6fc43f4f049de5b5768f97961e03387e67b371dcd8ad0b76b81d4409e"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "672f13afba77f471c1dc64abedc0f5f1512a654e84246f78b6e2efdbabbc4fdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "728db498c8ce8b79baabbb78ee2ba2ad4289c4c009afd0cb7b9c8706351bfd3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f50e1bebeb4f2ec7015d6a295aafa30a3b0704f758efe875d246b8c1023a905"
    sha256 cellar: :any_skip_relocation, sonoma:        "44180be33573f7ef7aba14e75cabef48acfd1228c7514a2cd94d6419cdb0bf7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3e274da24c6d42e3781ea937742fe1f89e9c66067a39ee4d7ebcf663dbffe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b27da3933ee11a45e9619974ca702cf8beaa2278b91dd8765d97810de480ade6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
    depends_on "systemd" # libudev
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")

    test_key = shell_output("age-keygen")
    test_key_line = test_key.lines.grep(/^# public key:/).first.sub(/^# public key: /, "").strip
    secret_key_line = test_key.lines.grep(/^AGE-SECRET-KEY-/).first.strip

    (testpath/"fnox.toml").write <<~TOML
      [providers]
      age = { type = "age", recipients = ["#{test_key_line}"] }
    TOML

    ENV["FNOX_AGE_KEY"] = secret_key_line
    system bin/"fnox", "set", "TEST_SECRET", "test-secret-value", "--provider", "age"
    assert_match "TEST_SECRET", shell_output("#{bin}/fnox list")
    assert_match "test-secret-value", shell_output("#{bin}/fnox get TEST_SECRET")
  end
end
