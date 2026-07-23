class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "5057a159ab09d2cd311250fccbabc115f6ad658b6419d6e82ab16e365b8eb3e7"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c0e9c8a6fc4425d9b1d277dfb98f8057f17835161d23e1daa5935dda44c8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb91d14c21549d4aa72455bf23a3e628c13ff42bf85ffe5dd4cc0dc9a00189c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a81fc3cf8120907b6329bd58f945b758ba73c04d342f7b92cec527fd4733bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a85e1cfe1f7a747d15d4e413868a11e872c0530e49f2fa9e73e33b3a330f1c5"
    sha256 cellar: :any,                 arm64_linux:   "8694a84a5206043bd1922569bfe605d5ae4836555d85ec6270d3d6fe577d2890"
    sha256 cellar: :any,                 x86_64_linux:  "88dd02a68ff0608646bd033ba7400ac933f5037223bff81722f7becb64eef534"
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
