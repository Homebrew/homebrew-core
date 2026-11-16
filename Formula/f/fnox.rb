class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "7b4c1174e59e48247f3044242fffcecc3fb4c8d3cf672b0de93e4c779eb30959"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3326424312dce713f0a4c547338c2cd6e5bfe7a494119d405c20407c73ecaa7c"
    sha256 cellar: :any, arm64_tahoe:       "3abcf2ee13a8e00b89cb7850dee9e3617090c3db4a206ba02dbee126198754ba"
    sha256 cellar: :any, arm64_sequoia:     "c3a6e56f593b6753462077e3c84e909400be097d0db5669eeec93362a49a4f7b"
    sha256 cellar: :any, arm64_linux:       "1156785a9bc5ea9d84ed0690e277f7114c938ede2fcbf800d0c3c575f886ab65"
    sha256 cellar: :any, x86_64_linux:      "fe280f92a850c7962f6d608518dd2842a9e2a47930b95a8902b0544071539d32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "openssl@4"
  depends_on "sqlcipher"
  depends_on "usage"

  on_macos do
    depends_on "node" => :build # Touch ID approval UI header generation
  end

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
