class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "2eff69f2e9388cf0735ee1ddd525e1645f577403483d34fa475d11870e79ab85"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e775a6109a92bde96feeed68c70509af4f422b688b7e9af983a203fa55a76261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a04cba0d74f6c460f2084117f09c5500a463859bfee1c0ad4173b817257dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af11969768f86901410093693d5215cee946b729fff0d7ffec0818795af9a2d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d4d42cd77c55c4d9122bb8698312dd586324a0d0852790bb5a0014915f1c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b86bb4a8ecb647815d5137fbe4fa819bf402637c5d171b7406d57162d741e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e11b47fabba29b68674a5c79cd52b3e9b7d577d1aa011cec2c15b177fa0d7b"
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
