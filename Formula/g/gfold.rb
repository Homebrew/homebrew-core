class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.5.0.tar.gz"
  sha256 "ba5afe509ef17f5cdde8540cfd9321001cbb10d49dd6324f22562d65dbae8738"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d60d01fcc4d949d385448343156ee494dfeacc91ce4f3f1292517d455989849"
    sha256 cellar: :any,                 arm64_ventura:  "55d732326ef6bb146960f4d291f9146f882fab21a1ecdd4db552474bbf1123b5"
    sha256 cellar: :any,                 arm64_monterey: "9544cc10fe9106d5f773f28f50481d5f90833f7203e1e13fb6b8f85275e6a5d0"
    sha256 cellar: :any,                 sonoma:         "f2fd71f5c5d944ae70b41642aeeb6c98fd5c8dc3dc27882b1973b6c20c8acdba"
    sha256 cellar: :any,                 ventura:        "9ec3069ba7bf5264bbbb2b0e7fef50608c1ad61981bc65e319678e2f5ea0f365"
    sha256 cellar: :any,                 monterey:       "efa17cc98e7064f71df72a1d80100d63c68cddb4d99672684c3121c4f67710a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f496786ea2247a8f28bc809fcc5c84cb879ef385a039ee8aa7b2e68e9d63c0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "bin/gfold")
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      (Pathname.pwd/"README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}/gfold #{testpath} 2>&1")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    linkage_with_libgit2 = (bin/"gfold").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end
