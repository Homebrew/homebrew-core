class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "c02b71ab4c10b0d464fba0dc6ddb20bec16ae67c61d029919b50d55d39d15c05"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "36ea322d97789f1a1b776d6cf564359ef0c993be9076202788379973115e4bd1"
    sha256 cellar: :any, arm64_tahoe:       "0690152634092b2e93d2d20afe699537807f5b466b20b1b9a338d56571c3a164"
    sha256 cellar: :any, arm64_sequoia:     "edf075c6db7f803ff4255196bf96e08115523dc2d8d1087f55daeaba799d3bd4"
    sha256 cellar: :any, arm64_linux:       "2c70e6fa51ec9ff5ff8c015612e78348b83f820e43efb0c8c7fcd9daf4872c6d"
    sha256 cellar: :any, x86_64_linux:      "45f157f047cdf929650df03d3fe0eca5c56cff9bd4d8a764124f8ecf9b88a566"
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
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.mac?

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
