class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.27.1.tar.gz"
  sha256 "3a6f82d3da4da62b2e5406bbe307b0afc73cd8fcc4855534886d80ea0121cc03"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7174811d0436635d569643460e7889adcb850d081bab4ee6aa0797352a5feb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dd2f247d1ff848588741a9c42da623f6420f105268eac01d8bd02b60d83f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a894a3270ecc1cf41395ffd576dc96c1f49c6b9f66f8105281204b9d9128a2e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d1b3c6d8e0dc7afc0e8fdf6df66ceba1267c4edf8e20bc1ace82def27e9d544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc8085b10b26c6ebd78a94d5847b9acc95f5286afce0d64c2fd091a119d14cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d0a81bed500193cd8580c3acbc28826352f9613735efa5c4f53bc5c2ba8d18d"
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
