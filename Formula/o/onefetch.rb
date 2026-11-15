class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/3.2.0.tar.gz"
  sha256 "6cd2822a8f118dc2799cefd4afe04f98933687695f1ffa39284d30cb58c909f2"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31f037022689bf5760d99236ca9b38578f73da147b24e6508a7c8c897084bc77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09e80967f787dd87f77c112478c917b04dc46471cdb145856adc6fbe997eaf77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b28a452af7889846268ffbcc5891aefd8eb4fedff87896fafbc157780a8fb924"
    sha256 cellar: :any,                 arm64_linux:       "01088b3702cf8fc0a1d39cfdd8f6050886f317c56e6184e395569d59d92187bc"
    sha256 cellar: :any,                 x86_64_linux:      "edafdf0d3aeec32795caa79186d1fb3e8a8337dbe8fdc8f20cfe0a73100c7dfb"
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
