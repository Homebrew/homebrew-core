class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "62b3e7a586cdf4ab4c4c4c3fb1f42ff8de8e4b36e24843720f65682b281677d6"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b5bf7beab672c5992f6d09c95ccab51c14f038ee14fb2b4ab3c3ef1e9f8aece"
    sha256 cellar: :any, arm64_tahoe:       "a384044cd06c468b337e0237ab951960882fc82f77be8c07d8702bf446eeeedc"
    sha256 cellar: :any, arm64_sequoia:     "96e430951890b046abb209fd2577ad8e318515e4fe7ece67f3e245ffa0661f47"
    sha256 cellar: :any, arm64_linux:       "fc4e58e02474b74d7577a5752202dba6d48af53475c328d43b96343a4b08268a"
    sha256 cellar: :any, x86_64_linux:      "9f999a6e9ea993f12c41b39eed1b02ee14160d4d31e2bf313e0925f223d1faad"
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
