class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.2.0.tar.gz"
  sha256 "fd7d69fb5b6d64e292877d87a77864d5081906b6e515e20b93348b7f05bd05c1"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "815c4318d69c91b36986c47f897fba9e5823d9b239998383bb41ec56f37daf2d"
    sha256 cellar: :any,                 arm64_sonoma:  "20ee790e3d75ec38bcb3e75bb972691ddf65a137ebd904e6d48d50278e104f78"
    sha256 cellar: :any,                 arm64_ventura: "afb783b372f3f929fffc61d1961cf5d97253df44b1ff6579f3980f69df3a5e70"
    sha256 cellar: :any,                 sonoma:        "0f2c1fb174b85d710dd1291285ab159f8e567c59ed63c510d54744f1ea4fbdb6"
    sha256 cellar: :any,                 ventura:       "66d397eea2b0cd6c707931f01062aec463d68e2ae48e009ed9ccb6134be7f2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25667769aa036ee9cfffc83ebae377ab6c80d45d0d9cad82b1cece4102a2b64c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cog", because: "both install `cog` binaries"

  # support libgit2 1.8, upstream pr ref, https://github.com/cocogitto/cocogitto/pull/433
  patch do
    url "https://github.com/cocogitto/cocogitto/commit/47689fe4f431d7b1371ff34cb430fbffc19f40c5.patch?full_index=1"
    sha256 "508a34432f907500d2a92940647501512e789cac53e85497a83b1b99089ae07b"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions")

    system bin/"cog", "generate-manpages", buildpath
    man1.install Dir["*.1"]
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init", "--initial-branch=main"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    linkage_with_libgit2 = (bin/"cog").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
