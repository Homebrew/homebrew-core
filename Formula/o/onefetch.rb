class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.26.1.tar.gz"
  sha256 "ff43255d7c138c448cfdd1abacb01c6abe0c3e3886024e98ff077b28d4dc0ddc"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6482c4a3bd1c2bf1202e23e62b055cb9b3266d5031a7a67931a1e8b3a6235eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "042ce885bb36b8792cf2abc76f8e29e0a6015b7643792431abb58210d1da9eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baeff95826c174e63cb9cc28c9209db27b32c89c821935be44b08ed7eac561d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fdbba646b655d06432d22b2fc52ad427e62fb5a7f160cc901f50fc39678919d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef1575b493a1fefa0a1b46c99362a6404c5821cc51772a8f0ce7e2c02f27b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "788376164e7dbab1edf623e7793e1c71aa662d6251e4489a630803ba3bb78813"
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
