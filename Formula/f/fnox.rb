class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "1c4f3e158ff3e53918e1eb288172df8fd9ffe616462badbed62a951e82cbd7a0"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a524470db57d28cbe14665ecab57805690896be33ac180de78e258523bc64a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725906862e30ba127b8ae3f6772fc52b56a4b6968e288d0946acbeadd125b803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a042756de8bdcb0a407dbf73f669a3dc8d237b76f2b6340254004ae42e777e"
    sha256 cellar: :any_skip_relocation, sonoma:        "04d88c9884b5542a2073d3e3a1d67d94395a99533f712e0e85e648bbec454db5"
    sha256 cellar: :any,                 arm64_linux:   "b7750d2aa68142e4e0d5d4393b8d556b352a6128c04926c644c14cd12d9c6e4f"
    sha256 cellar: :any,                 x86_64_linux:  "a0d904d764d0b231870f91c53b2e0e5e33f2de099c4e8eb9ee5b4bbb89d88b6b"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
