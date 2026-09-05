class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "2a363b119d2380753d61890b63c55acbfba0ec9060175d1fa71450c8369347f4"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dfdf1353971a9c58c67cdc3a5a6a2db6703d02c0892d54b2ab5db02ba7bc40b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "082a46a258a47f2a780a458781790d1589533ef46b2a9178617a8738280a2df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43770dee6abfdda665e36ed08dcc1817d3903ff62f7df4c38c57b371cdcb93eb"
    sha256 cellar: :any,                 arm64_linux:   "2f8fe610baccffb0fa79cf09ea5a7582aa4494a6190d32dac6596c8f5860d746"
    sha256 cellar: :any,                 x86_64_linux:  "2634522a40a75be665d9370947d85b4ea6bdc6b3f91071236ec3e13a33fefb0d"
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
