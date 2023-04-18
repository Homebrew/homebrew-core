class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/2.17.0.tar.gz"
  sha256 "fdaa0df2d7c9c75fdcb6421d03647ee64dfc9da839bcd90d6c5d34595d35e0db"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "21298ae91d0424f629d39346259d603f15e47a28e710e716c0724063e52597eb"
    sha256 cellar: :any,                 arm64_monterey: "e16ff3aeed911a579f0fea028d72d64e66b0f392b96785c7bba47793fcddb9d7"
    sha256 cellar: :any,                 arm64_big_sur:  "3f79b62dc77267d7372f7b1eae8ee32b5b0ca8c59c818ef9c8ea1d7ca42a0ad4"
    sha256 cellar: :any,                 ventura:        "9dfd7ea7c1fcd5c19c2f5b155297957c73f06924fe7fbc7a79fd12293eb82c65"
    sha256 cellar: :any,                 monterey:       "96f8363794970b3a44acef3c2a921b5b77b8fb0823352072229dc78814a0d930"
    sha256 cellar: :any,                 big_sur:        "0b7830d41dadc49b050152a7bd382fb7a4a604b37434207c79d0e5b2027c14f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bbfb563727609b9968be90dbedb4ecf0ec0ca7ed1a6a831f624465d8f1c5807"
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
