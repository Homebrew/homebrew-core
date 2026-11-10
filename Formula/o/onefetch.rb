class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/3.2.0.tar.gz"
  sha256 "6cd2822a8f118dc2799cefd4afe04f98933687695f1ffa39284d30cb58c909f2"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f27ec4d6d1f944faf78110e3ba2f320af2f629fa6081f5c72da269461f2ff236"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d97c113c8589c535ec596ea5991e7b0f572898f22d8f55a21d5538b5fcdd10a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45795afafaf29956bec130a07af6bbb2a44ed3caf90a2432b367f9623e57ad41"
    sha256 cellar: :any,                 arm64_linux:       "a5572d18fb4ea2676a72ba0c918fb6c084dbff4e03388546563c67d30bfbbe3b"
    sha256 cellar: :any,                 x86_64_linux:      "aa8e2d2426b21ca452c53d603ba73663f487cf8817f0b9d9d1f8907fcb812355"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
