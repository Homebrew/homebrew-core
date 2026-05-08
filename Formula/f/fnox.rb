class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "ba1534176bd448d0bc0eba1ee04299700ef42ed8e758899fd01d0546b38f011b"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e0e94ec641b79f37be02167405adbcd37495f5cf8f3c90e1369d491277d460a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76c0b99d54988b2707b4406c0aa839785f42db9d7b0892c8239b09a081b1e7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4764e9336fa063f22fb0db0d05c174d6e3281ff7690006b3552bb70c0d77ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7bfeafc95ad88cce8b4862facca244cecc820b553bd031f93b5d3f3fd57f062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5caacaabce509171a6e15362fdf79de7459913de9e8c41ff829bfd3627aa334c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d800327bdc8e242b21a3ac7808259589ed9869b73bef5eb63bab35fc58eabb4e"
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
