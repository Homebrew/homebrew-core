class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "f25393fc2769f7916698d858b315244db34cc388c582399257f61cf4ebdd0981"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2066efcc9e888c602acb2c2583f181d1e47eb96803ee4b8db29ec81b162300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445bd2eb44f942fb71353d912e8b6e36994fad9751b390b38ecd4697b1e7067a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8520ad4b257599c3766f75186b32183f49363d3c6c4c63ac090921e297268147"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5cefc5fd6f9ea4c0c4e8e94c0d9cd48426ce5f97b1530c543fa34594fbb3ba4"
    sha256 cellar: :any,                 arm64_linux:   "f716e8794e84767ff2aaf7ffcbff495fdb1417003f9a193a780516c69fc7c2bd"
    sha256 cellar: :any,                 x86_64_linux:  "ee1922722f28fae66ae715d60ee24f529d34aed78b29470bed14791f973f9a5b"
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
