class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.3.0.tar.gz"
  sha256 "bf78a06ec20cd33c4f9bcddb427067de34d005fb6d4a41727239b7b1e8e916e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "653bfecc7e5bf0d31506f6b7e0e6a39d42a1786df4320071e4bae07dadf57f0b"
    sha256 cellar: :any,                 arm64_sonoma:  "32504a5766eefb9b00ce51cb505f25c287c683bc244f29792113df3b8b7e2131"
    sha256 cellar: :any,                 arm64_ventura: "0f133691154d002414e87fde8af45598f7e1bbb73db79cd0a36cdfadf7bc0978"
    sha256 cellar: :any,                 sonoma:        "de432bba61a74787063511a9c4346b036572c7579748af9056c583d9b0f22a8e"
    sha256 cellar: :any,                 ventura:       "3bc5fbfef19cf37d680111f4b16d9bc70f046ffcbd07f801d5ed09769724c8a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abbe9fb10c06ade07ae9790a397ee02355f026fdcef62fa482733a5cd63dfac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa05ff9b1e802473de9ababb53942b8c3aeb6ea3d7ca9aefbdf5a80e53aeb61"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cog", because: "both install `cog` binaries"

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
