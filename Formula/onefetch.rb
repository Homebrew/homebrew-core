class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/2.16.0.tar.gz"
  sha256 "948abb476a1310ab9393fcce10cffabcedfa12c2cf7be238472edafe13753222"
  license "MIT"
  revision 1
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "805144105bc780c2e9fed4ac8cd633acf1ac03d4ee8170d9cc6736c89d22e3a3"
    sha256 cellar: :any,                 arm64_monterey: "340b26b795ffd29de364a35d08bba3abdf4d692f59805de23c3b166e79a0fb2f"
    sha256 cellar: :any,                 arm64_big_sur:  "06b854c9b34f1ff647559e403b484e68b682a08a0fd76de641ac896032adfa4d"
    sha256 cellar: :any,                 ventura:        "e4c7be81bdfab34aaccacec8ee7949a097f896ce65aae791428e39cc95771593"
    sha256 cellar: :any,                 monterey:       "7503ce1ee1a27c5b33a6a6b9247bccdc8934a8e0d323933fcb265c1b4e75db4c"
    sha256 cellar: :any,                 big_sur:        "74154a7c248286f82520b9f194bd5fc453265860fd9a2ca9d7dc5aaed3b32da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c74924ce9a037c3475c8613b0aaa6670983816b7136e10fc1f3fe29d39ecda4b"
  end

  # `cmake` is used to build `zstd` and `zlib`.
  # TODO: See if it is possible to use Homebrew dependencies instead.
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)

    linkage_with_libgit2 = (bin/"onefetch").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
