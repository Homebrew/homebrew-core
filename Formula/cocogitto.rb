class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.3.1.tar.gz"
  sha256 "ac6847ce55ba284184d0792afb53c6579da415600bc1b01c180dd87ad34597d0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0583adb5859665c58a9b29096ac38373897a4e3f8feb5ec9fa787f7cadaeb091"
    sha256 cellar: :any,                 arm64_monterey: "8da40f6052e3f885aaefb6b503b2e1a7e80350b5e4d254f85dd82d3341fec642"
    sha256 cellar: :any,                 arm64_big_sur:  "e073b9d86cc5075212b03b4063bf8b3e2e9772d89c51338ea2734c121554e6b7"
    sha256 cellar: :any,                 ventura:        "bcfee79519b9dc44686c6c24c93de7886dfb58c9299d61b6fd992778c8e1390d"
    sha256 cellar: :any,                 monterey:       "247b6ae88bb6e84735531495f35f8de1ce27d74002072408ff0c590a9ea56b51"
    sha256 cellar: :any,                 big_sur:        "6adab7d771e341bc4d6452b625bcbfc3531ae86b3e162d43c2797cc9b93aaf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1d334a3ef113c5f3aaf47029fb1d3e259c89f82f086743db634ee21df51bcb0"
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
