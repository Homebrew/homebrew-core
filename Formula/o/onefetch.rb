class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.28.1.tar.gz"
  sha256 "d51e7411588b3aa8c4d747199941d93b8eb7878d8cfd605463a4c3da125b6be7"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d505ffc7a24797c9a4b1db56833969dc101f69726ecb075a55eb73580640bed5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f370ca8df4c094544ba3c249ad5eb8b060c70d4c628549b3311976a781613de5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f126dda4c0acf2d0ceee0b767b9081cb4c8db0b051b31d5e7b3562b995ce9ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9aa40a3ecf60c99558b00ae511d4dab43b44acca32215a0f52731b47b35e9bb4"
    sha256 cellar: :any,                 arm64_linux:       "63c15416e4b401a88f09e6e336e14f0288125dbea1709c3dadd10d497f087785"
    sha256 cellar: :any,                 x86_64_linux:      "f503f9c162da583efac9d85fe900d2cdca8455e6c04894a6a9e77f3ea4a96f92"
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
