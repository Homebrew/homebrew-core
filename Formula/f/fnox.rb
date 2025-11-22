class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "21689209fff171414340c80bfb1f551c12819951553ef404f89bdd4e08f7ecd0"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d774f86b454daac9e6b1620fad10f08395fac363293dc5d40a3eab0b49cd4a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bdda0748559f5737098564416974b80e73583a6cc333763eae17434dd7bbde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220a418b123cca154bd7afb45382a39198301c1507cb76f07a61ccc55c16f654"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea4cc8d97b024fd56acd168d447cb24f594ba2ba913fda77c45956dbad38903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a15b6145e5e844d0a89d8a599a9934826b359f9e7c4479346fcf7fa229cc6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f1728faa79c4de5bbf861d1f1149a33972d53764437809e7cda055904337aa"
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
