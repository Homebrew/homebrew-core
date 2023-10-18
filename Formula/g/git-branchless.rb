class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f9e13d9a3de960b32fb684a59492defd812bb0785df48facc964478f675f0355"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "905e64741afeeb899cb6ae572b9b360ed5ff9a0942e09953d2611d91f2a2f2e4"
    sha256 cellar: :any,                 arm64_ventura:  "d8e78bd02c94eefa05ab21b12690308e734bc05d4e44a75e27152bbb2252c0dc"
    sha256 cellar: :any,                 arm64_monterey: "d110f230e10e5fffa85a73ba47b5cf1caedc9e9407c0fd5fc5a5d71eeefac1fd"
    sha256 cellar: :any,                 arm64_big_sur:  "a21285b24658f3df388e02e21f159bea00576d19ef9ea58371d1bdfb476e2a23"
    sha256 cellar: :any,                 sonoma:         "ea5746626a621330c76a072e54f7f65c5d99af3c1f1919920bb7949a94efef40"
    sha256 cellar: :any,                 ventura:        "652de83e86696533f0d9637fc3b8a299c32d3f9e89628fac30aa70b7253b85ba"
    sha256 cellar: :any,                 monterey:       "87ec040da2cb1e745f7e8ac3b71c11306f41b8e1d160f3499f97f10f4d9316dc"
    sha256 cellar: :any,                 big_sur:        "e8350258ef29fd41b09ca1ff0ca3ca2beb8cd1e5a7886e33fe3db00892293ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5dedce96d6ff59927b7ed0917cf038cdcfc313ad528e0c8b13a6e6c8c38ad5"
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

    system "git", "branchless", "install-man-pages", man1
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
