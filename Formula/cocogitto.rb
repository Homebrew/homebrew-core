class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.3.1.tar.gz"
  sha256 "ac6847ce55ba284184d0792afb53c6579da415600bc1b01c180dd87ad34597d0"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "cadbd9843532adfa7c5ec9b2e8495348a17936485f7b522e0d9f1f423ebab2fb"
    sha256 cellar: :any,                 arm64_monterey: "4cff9cff931d87bf1f0746968612d4be56250ff1ec7621d5e3e6497785bab483"
    sha256 cellar: :any,                 arm64_big_sur:  "7673cfaaef65b509ff587e37bafd0813efed0ed29a2ba5030ae3fd794bcca22a"
    sha256 cellar: :any,                 ventura:        "576d3f623ec5253be96ca62375f32593094b6e32fe54575b4ba25934e53517fc"
    sha256 cellar: :any,                 monterey:       "0bc187844bb4302fe4f27c6416bda0eb776c828858c5cfcf99ffb701fe829589"
    sha256 cellar: :any,                 big_sur:        "f5f9bd23c36a1acff11e349ccea9fe9ac9d63bdc779b2c2d1f2f9b8e7ff1ab4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f877495a39f580d77c5908946111cdccf37be78236f13e2801e50fd1a1b807e0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
