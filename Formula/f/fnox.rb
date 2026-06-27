class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4426832c174514bd99379f419467c59e226aa2faabc497542a5427493f78167d"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e98772aff48b39b94e928592590fdc461f186c447f13b95ca99216f5b084209"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d26932016f218cf4fffdaf306a4b17c7834dc68ccd7ee0d37a186627b9d08f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599172713ae9459f383abbd864d1a3494f1c45e9b8427fe1bfd8905f1dc539c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5c6b58c89097f779fc560dfe113c57b18f6e34ad74ee51c21d554bc3aec8ec"
    sha256 cellar: :any,                 arm64_linux:   "9dddafeb167f01ea91e2d76a88099bd6c741d27c641cd4c295f951f94fc1e7f2"
    sha256 cellar: :any,                 x86_64_linux:  "9fa4e6be1200aba4d5fbb28dfc04b5d0a5a0068da76e17f0397c25ea2a3a3579"
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
