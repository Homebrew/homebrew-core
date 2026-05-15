class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "88854d5bc0231790c81c3a3758a834f8cc6f8caa99cd3109c5807de2041e6d40"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a84f0d58ce3197f16f1965965ddaa929b76ab6855ac561c3f8986470b1fe819a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "986a30817ee4984b1b52cec2aa2653b505002acb9c1117d2652c97a4c9eb006e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cb110418cf0a90bdd5e14756289fa470f4ea68363a9511b68d8f3488d503ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "61f1cc99eadf9afb28909068f1e4e884110f7d0a067bde9fe5e0e519f5126779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a160c816544817ba336135bbb2e2544fd218d43ae86383c04c02f934ed8a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e882a4fbdaae0f30dfdeacc1138040776377af1bd5137e5404ad530884875d57"
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
