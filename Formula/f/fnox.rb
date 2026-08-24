class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "92f24edc3d91adfb1fdaaf1fc2d26e6469445a46d7496d0cebf7844de27593c6"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6904b7416c4a698fd76fcf5ac1c03b7803890ef97def36170c2010ac28ae7cb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeca7aa9a65aa2322ba3041e7d5a3ba4b8780cbfbcaf0c684a8a78540b5c3bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cac28c5dc9e21b4706951893949891eba0d13d04d892b32013becbb80780b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "83aa5b486019b02901ba91a18dd3d4292c4a25b9246c1629d6c6adaa0647f74a"
    sha256 cellar: :any,                 arm64_linux:   "f4c6edd8b0d984c8c0b59611b5286916f39d269154de48affa766627aebc88c4"
    sha256 cellar: :any,                 x86_64_linux:  "da37026d412723813be720019a8d54b77efd7338cc8a2feb97ae3b67dd0fa8ff"
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
