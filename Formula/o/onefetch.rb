class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.23.1.tar.gz"
  sha256 "72e87f6a62682ad88aa07b02815ee1e2863fe45e04df3bba49026bf3edd10537"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3993a0b6e343544f34263de289c9c5853d7cef5bb89baa8e34007baf5d29ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ca98926eb7dd75d60b081b4d8ee23a2d0ac6442ab9bbb4b1b1f493d377cd42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8197b79c3f38ee59ab1566c8207a18cacaf29b62f0e18e4b3bcc0290042e2271"
    sha256 cellar: :any_skip_relocation, sonoma:        "75d5a293661170fc68a59e9eec180cd862993a112b890df6baa314ef52c49a88"
    sha256 cellar: :any_skip_relocation, ventura:       "cb64912fa0eee5b4c21b478b674e7a60f3db7c0c798e64634c4472f74eba92c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eaaca384c0c07d80f8e8364fb651dbb2e95e4b7094634e45c2b951f6b0b2c12"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system bin/"onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output(bin/"onefetch").chomp)
  end
end
