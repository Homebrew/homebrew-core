class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "60e69aad2f0501c7702564a3c91ef91038d9a174bb4acb7047dcd0025792bb0c"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "850129cb773f52a13396408c4d1089f6490d844e1033a7b960f72379e544d922"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659869427d0deacecc26f707814fd20dd7b5e0515a176788e3e50f6c8e35e86c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfed8a8b98ad59d7f27a1bda8c335d960a875bac9c81c9280ec822b6293b9794"
    sha256 cellar: :any_skip_relocation, sonoma:        "3947983253cf23bdbc3fb5b2480ab755e4f7be34c5df6f8a389bffa5f1094ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3423868f8c23ff75c98de4395e60975573231dca4e3ed54a93fd3df4d19445f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c526295118f1ebcd4e204295a9ac049106ed6836f2ab5f8b4ba4923ba352e391"
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
