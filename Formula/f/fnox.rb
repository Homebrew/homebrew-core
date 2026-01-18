class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "b689a8919805f08276ac06e3014db6fc3450f739669aa5a62522451e46f7c682"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b045e8cf026fa84c29997a5b200a8c69142f6c71eca09c0009dac2b22f748fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a996896b1b927b9d62dd78e9b7b02e1d04e038565c19ca94bd0e689db6d3c99b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9df77d3bcd0436f7bfe29b0f0adc9485abd8d9ae5d9d9c348d6d3a975c8e874"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc4c61b1e3627609deb446629e98b1be21c945615a6a576c6e42a53d903bf105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba73e3dfc16c7e6fe50d2ca961df1cc7c7994ca807c0d9216e410b95cbc8196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc707aadb46bae82701a977a147e647356d34a9eb4029be0aefcccf59c323042"
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
