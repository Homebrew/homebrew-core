class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "371aa8540f5d701157771c36bca5ac3e564e54d39ca9218d4cd1d9e1122387ef"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a9c171b9582ed7e6f55c781d573994cb40c70ced913101d941cda37d656454c"
    sha256 cellar: :any, arm64_tahoe:       "eb9aa1dfe5f9b52ff446585c5433bcee5972773ee85a17e2b69918dac456cb35"
    sha256 cellar: :any, arm64_sequoia:     "1ea53d685abd9fa939ab17fc70dbd28505d52c359cf17b1253afcb3fecdbdf81"
    sha256 cellar: :any, arm64_linux:       "b49dbc6bb39bc15ea6d3120c33b7135c73e4223ec55e801f782b3e148d3ecb5e"
    sha256 cellar: :any, x86_64_linux:      "351e599993b5feb9281ad81ed05c1c3c6ed6d4a1b81e9b6c25f74ec182054fcc"
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
