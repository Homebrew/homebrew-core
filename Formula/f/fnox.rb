class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "dd0c26925dc439b187aa38613e564f455c01f3122e6a6f7c5bf24ed9fd05efbc"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "906d4c14e881faa88e0cff07577975713f686e244eceab503fcb9bad5b2ebb28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43e4818d9ff7cc8e3c1bec41c6964fea17f17f79165bdb2e243aaf3b0960e542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f004ec3bd2adaf1313ee3ab77e0a27d62a9c5a90f8ef8f2db8f15045a18c65c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9cb3b79db78811172b0b9bb92aae13bff06a9b3cf3403ed95e6cb6248f25fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab10d4da15386f19c013597235226d2cbbdf692dab2833ad41d3d664b56ae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4673e7bdb9a3bbf138d2491d35db94dfaee9aec906b767e0ef4514f3b151ef23"
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
