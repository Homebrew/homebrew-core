class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "6504ada7ef5295804a18b08f188fb9ea7149cad62ff381f68d6ef6315d98714f"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5e7a1c7ace486e42020a9f7af2e13f1147c08cc3ac39a21a42b57b8ae69ac48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b071b639fb54f8e87bbc22df5845554a3c30d61572b1ded2ab6c61c22df8a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7f40d5fc58bc9d1b3062981a5f2364a180de3d41534877264adb18a297f9ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b3f89c0bc424b1c69b14c5ddb374792bac6947ef1644eb9dae8ca42ade098c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce405030842d437b3a0f400530150fcbb35f436daf2c906510b9b94e787bce91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd46e8b8c5bd90e501bcffa18b70c6e28579181f7fe8581ba039447d2e8a2d9"
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
