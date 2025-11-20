class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "93e47266a278ebdb203e3cbd96cda775923b1c1ee15cb6791a67e2dba7ab54ff"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d14f559608e0e3c6028c2087ad23a3685720ccec6dd6a652e46e2f42331a584"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01cd1d29c7a2ea35057f6a541511b4121d6d9493197c5ddcbd5dcbca9f2ddee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c93fc57d70ad41f741644d0e21874fdc8ab9f8be4c0b31ad2ffa65536e661472"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2b3eb2bc7cf9ff61fc2656accc94b276763b520574fc43cc11a70ad1d8561b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5e7319c1eb7c94c41648eeb9ff6f4e06b4df258b2ba2b0bf24bf397841dba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4064aefd82c5a176ab9c35e7ca565c68b5a2411502fa10e18b11052a3eb950"
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
