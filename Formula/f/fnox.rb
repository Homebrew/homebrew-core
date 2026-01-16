class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "359449f43698806a94f380566c0341de73ccd72bfa0dfdb8b5587174b51ffeb3"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88a988d433a265ecb127db880eb6c2b0072f1cc8dbc87e51ab3c325753b041fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d799c9caf50f740a89e29981a12181fb0160f59b036186a1b2486e63a571468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724d39de63fc3e95c34e15f039ce9e3791f5b79edd7d99c233f3e9508a85aee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4633e816c203ed1bd29cad0d9f3fc461efd48a3ff14954ae2ea322b51157d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf9a83542323f88540b2c8245541a9f3b0d2dddf4fa4422fcfd006f9a16ca7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd23e3a5670819caba5947d0a60ed80e8893a752e43dd2b235734eac1fedb1df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
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
