class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.6.0.tar.gz"
  sha256 "eea9655f4750cb2567eaca9ca4968a3a639f9003242ef733b205bf5410d90c86"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a18e6f99bc8980508958e84de42620b43f29356033cdca605edbc9a4609aac7"
    sha256 cellar: :any,                 arm64_ventura:  "525d3455c07596e577a49e32b758faf76745e8da4b9d87989843ba195952471d"
    sha256 cellar: :any,                 arm64_monterey: "d03f406d6da7c32a17d60c5328010e8b0c8e2a4ff4c7aa93ec6540aa798bbdd4"
    sha256 cellar: :any,                 sonoma:         "e219670240bbd846d552a073c6bfc863246c8e8f53e11b38b25e211ca76f635c"
    sha256 cellar: :any,                 ventura:        "e8ad261793d24dfa5dc1b1843865dddbd4ef132545554a65a150cbaa769ae59f"
    sha256 cellar: :any,                 monterey:       "462d651dc15e2ea09de66be8fa9cfd39f77e2232dc8e32d70d6fac2fcd164274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2db3d7839f814f183e7c2273c54672a1eeef2ab0ae22d49ad0d6c159413fef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/cocogitto/cocogitto/blob/#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.5.*, then:
  #    - Use the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.5"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"

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
