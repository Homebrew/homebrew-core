class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f9e13d9a3de960b32fb684a59492defd812bb0785df48facc964478f675f0355"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b110734dc1ef391fc9b2d2bc8a49976327a7692c0d584027deeadff70939de96"
    sha256 cellar: :any,                 arm64_ventura:  "a86fc202383af0bb6290f20560bc3e1ba91cf1580bd5650d84141072953a2fdb"
    sha256 cellar: :any,                 arm64_monterey: "de7eefce124b0427145dbf4bbff6135199480782b041dc406137f5450d2ec491"
    sha256 cellar: :any,                 sonoma:         "c35f286464f34d3c2aec788d4fe408b8544c45fdcee2a79c67c08b2bed03b551"
    sha256 cellar: :any,                 ventura:        "e7310a07e9c3359b36aa9d0e5906b2e19a9a5d76f8e66a32a5303c054ad278bc"
    sha256 cellar: :any,                 monterey:       "827d307d7afe2c66823d91ff6e62acafa45be03d99b4271ce9d3208f76c099b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7e6fa4d5b29d4b486dcf0f5f52dfe0797df36d11a2a3d8697e8cc357652da1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/arxanas/git-branchless/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"

  def install
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip

    linkage_with_libgit2 = (bin/"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.6"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
