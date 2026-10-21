class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "1302d6c5c68a8401f65ef7d84050cb75fb05fd4e53e09fe7bda5c1e1717fda16"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a3b2b69920fe8e6ff5b5429dbb47eec8111949d4f04ccda8632b3320ca46ad4d"
    sha256 cellar: :any, arm64_tahoe:       "06db4e099b6a4aa92c42e2d073b1c45be00b9e25df962cf626c1c68b6f6bed2e"
    sha256 cellar: :any, arm64_sequoia:     "19f885146ec9eb8844d0e4d8f983b763b6327475d5e2fea5aeba990adf1d0284"
    sha256 cellar: :any, arm64_linux:       "bce0c833034bb08e0783513c7c66347274976e02b50dc5a161f18508907651ae"
    sha256 cellar: :any, x86_64_linux:      "95b56fe17ef3a24127aeca47c494bbda48e0b7b391e79e8acdc4a48a8a7d0298"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "openssl@4"
  depends_on "sqlcipher"
  depends_on "usage"

  on_linux do
    depends_on "aws-lc"
    depends_on "systemd" # libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1" if OS.linux?
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.mac?

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
