class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/2.17.1.tar.gz"
  sha256 "37b6e6c2623b78cce807d03e5a3e9f21a4b86c6164abbcfa9846379e7f6ea9b1"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e51739c56a57ac0ba49ad638d8cc19f87bdb3fc2bf7e60618db2f432a42564b0"
    sha256 cellar: :any,                 arm64_monterey: "973f012998e73781e8df14770b7cdc14c5a3cd42aa69eee24b2a742d7b1af9a6"
    sha256 cellar: :any,                 arm64_big_sur:  "a7d276f12771928b13dd1cfd66d30f733324afe37cc1d2349439efd6a8c93064"
    sha256 cellar: :any,                 ventura:        "df78e648a2300d10db1e7648d85deb6751bc39664117e4dc7b0daf0f383970c5"
    sha256 cellar: :any,                 monterey:       "e39b82eb6ba0bdeec7f95caf64a8c6ff1fcaf4afc29f93e0c3ad326c1ae119db"
    sha256 cellar: :any,                 big_sur:        "49dd2c5fbb18163530991f34a3f6e1dbcd6a07b668105c6267620a1c4200452a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f03bcd616b244a701e5d61a7e5df9767e9f07f87df68ef7d7445f0a55f0140d"
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
