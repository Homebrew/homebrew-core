class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/2.16.0.tar.gz"
  sha256 "948abb476a1310ab9393fcce10cffabcedfa12c2cf7be238472edafe13753222"
  license "MIT"
  revision 1
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2b622372e6563eaea8cda4eeb49eb0138142bcfdbc82139ab6be3377bce39d3"
    sha256 cellar: :any,                 arm64_monterey: "1172d1490ed588cf1390cecd1cfc90ff149699acf876392b8df58079188e99f9"
    sha256 cellar: :any,                 arm64_big_sur:  "7005c234c79096e3e2eb5b0b82e9d021c5796224516f2aa749c7a0b531745650"
    sha256 cellar: :any,                 ventura:        "f9a6b273abae4cd5b56ebb2f2f374516932c18041a03529f51b19a32ec2ba121"
    sha256 cellar: :any,                 monterey:       "c04b0d6de349ac2ab3699140397f2e205df088ff72f8d0fd1fec0c14e52c3096"
    sha256 cellar: :any,                 big_sur:        "1b3697ce6de90ccfe696fc36c01e0c0f0515eadb45c569bd205d91ea9549d67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5317535209e93052c407973379b5400d10e80fe48a3fc0af43997e8be1cd982"
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
