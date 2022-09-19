class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "8af14d4e14373e2c0c0b6473b53e51be1ec186259f5098d11a0241817cf139a8"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e05f83d3a1fe67503079a84ea0f8651f8debd1f2748f5a776b3d5b64d7a46e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66447693cbdd2ff3aae06724ec22f1c07a2e3b84dac1d81445c4620fc41040db"
    sha256 cellar: :any_skip_relocation, monterey:       "f6b4215af45315b369bae1a39e2918cd9fc1083c2c6d4d22acb0cad06e5e2a38"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aad30bfec3ecd0b3db4d6f4d01f6c58632498388d52bc984e1c5e96cbc8ed94"
    sha256 cellar: :any_skip_relocation, catalina:       "115ca7cc97fcb829e7cf841fd7a199545a2a500faa982305808593efb1cfb6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4529ca2e9734d0a2667b63c2a135de5034dfd9bd9a5b8dfa4d672b19125899b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
