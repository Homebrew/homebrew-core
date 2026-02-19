class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "e3fff95624c37902f73dc3960a46fa50358c735ca4a50e7a04429462219d8f54"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6896a7c7c78f797f4a01fe4eb4b8372fed1b109275f169cbc5cbd1f573718b02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb23788f735f78e8f313c381dbf532f7d4cb4781699c9955d259e9b89391a009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b638824dd0ecce6d34467a6224da190bb4a3a7913edd4df88c782b1ea55039ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "90a45a730939092f52a87d4fffc2dcf8ecfe8c738e9c50bd041f090822a94aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4378d8f7e7af7c035a2db8ba8dfaa2e4196ec052cbfdbdedacd47e556c41f656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "897673037f39bcf3c5f31c2c11ee75bbe9f64e18c74f451e41d9baa1b8da79a0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
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
