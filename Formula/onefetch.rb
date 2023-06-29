class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/2.18.1.tar.gz"
  sha256 "7b0f03e9d2383ac32283cfb9ec09d10c8789a298969c8b7d45fa0168bd909140"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7b09d80fb4e0e4624aa30a1fbce5ec60af434f8db85f421a89d9ddfbc033dab"
    sha256 cellar: :any,                 arm64_monterey: "85a14e0c3a888845f85c5de4107245a6bc331045ee96ef6a5c6bd27ee7f14b9b"
    sha256 cellar: :any,                 arm64_big_sur:  "5ebce0d46976838b8a4cbd06777ed352a4120940bc9f874cf1d110f4531e314c"
    sha256 cellar: :any,                 ventura:        "ba1165769b47df32a7ea6f18c9640117d55862aa7c21504ac25f0a9667362820"
    sha256 cellar: :any,                 monterey:       "630a686f791d1aba88e3490e499cf543a5662908e8b482769bfccdaf5ec09aa6"
    sha256 cellar: :any,                 big_sur:        "cfc7e13df7690999e2f4b173485d541a2a696c9af51fdf3f756342f3874306ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36aa89fcd86c7867ba44d078a1b8eef44ee4e5f67cdb04598a5316bf93fe041f"
  end

  # `cmake` is used to build `zstd` and `zlib`.
  # TODO: See if it is possible to use Homebrew dependencies instead.
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
