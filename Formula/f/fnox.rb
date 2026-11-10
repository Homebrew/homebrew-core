class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "f870de49eb15bba6531f6e7014c1013f703d3cca7ff77d56ebeacc488f6b6c8e"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5639963bb2680deabffff3a2c3ae12ef977c5ed25fb852979e2cd523cbc98e92"
    sha256 cellar: :any, arm64_tahoe:       "42c6cb610a03536a340bd0690b5e3b6d3a197c80c9b8a72db39131e018866529"
    sha256 cellar: :any, arm64_sequoia:     "75c2f057b30bb124ae8930d8216d68722af056c99c6e248389cfef40d3380cf1"
    sha256 cellar: :any, arm64_linux:       "322d8a6e1200c4d153632dfe1a60fd6c503b4624c105bad07427d1a5c1160b94"
    sha256 cellar: :any, x86_64_linux:      "199f7613500460066513737f2ee03cef06e2f33f1f4a74250f3e5062e7230e52"
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
