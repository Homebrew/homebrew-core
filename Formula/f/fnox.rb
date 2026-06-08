class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "b182ac724872ddfe268ab4ebf57b3f830d3468c03fcf2fb6afab5dd1c609b277"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a86c66d176baa4d250d5ad8bdec87ee39efd1f4de03a51efd0bccf3fdaf4b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf1f392a9b5c04e81e310b92e0a83065b072a471fa139032070c1bc35442948"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0cf0a83d68d26e24a02ec0d8ad34e0e9c1bbc0f4f556c3b000336cb52b2a057"
    sha256 cellar: :any_skip_relocation, sonoma:        "299214c043b094749e42a10a8167a383bdb0e9544bba0403ae1dfc1d144491e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65117efffa4435c655cad18475d9abe46ba173d2fc69487b41454a846c38dc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac8836a417bf02c8d1d49f3c110e2922f78d115bdf8fafbdffb3e0e35f496b1"
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
