class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "0e9fe150758c28ddf17cd59ace609c59b471455a0550f7a75335ff71f9baff1a"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b171ba1ff3c6dfeb48043c04d8d50412721e6781f2864e8548e15446fa9671f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f597f20817acb0b6af7f0e427b0f8b3bff8c3030ae95f1cce7f8032c35d4552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "475fbf7735b8b29c08f100e4e1be70dc58644dfa3f05740323af292972356db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbb83dcc0f7cdc47d25cc58ffede7f4d875003ee85b57ebf517803a4e5607302"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0d3143bd5344a45c6fa81b5f33cc31a4fdc6dd305fe5f29b119c859b533fc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "722bbd7ffdf70b0453a701500044e74a41940ed50377d0c669d734c9ae1d1a8d"
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
