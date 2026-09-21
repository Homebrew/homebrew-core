class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "5df718dd9d7a071e5112baed1b5ccf9e096554ccf2a118bf1af978206836b722"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30a801ff9d9b1da17d59458accc9b7557cbe8070ca5ba6d0144d7cdaaf4ce954"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eef540d2173c50f5760743b75ecc601d5e06197a63bc14a41960daf530a14d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c43b9c21846735eb1fa67d1d630df3897a1dfbe71340d070b748df8b686dbf32"
    sha256 cellar: :any,                 arm64_linux:       "c874cf8aacd094fcac633e0b8caec686caa53257ec9acb406bbb720204fb15a0"
    sha256 cellar: :any,                 x86_64_linux:      "4ffb3261c66be485c32968148a45034bd425fec75710196075a7c28d3144a0ca"
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
