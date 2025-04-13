class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/2025.4.0.tar.gz"
  sha256 "47e397843bdc03cdc6711e56dd51f8b81e598d02adbd0ce3df0c7979c5d89758"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d591efa7fcb9846f9d0727ff45facdd64a9203881a8c975eb19c1aed42c898e7"
    sha256 cellar: :any,                 arm64_sonoma:  "cfc15cc0221780afbabf5d41bc8dd882f217a13355f501ee2627a634fd9fe7be"
    sha256 cellar: :any,                 arm64_ventura: "ccd245e5b090c845eec586d0b8bf6a82442eece9a099d4f433611546d47bd438"
    sha256 cellar: :any,                 sonoma:        "ddacceb6c48dda9ebe01226f479f9993f5eed9e280eef8f06e4c643d91c261e4"
    sha256 cellar: :any,                 ventura:       "ee2c81b52a3f262a1147738f3a662c6004bd8d948cdd903ae073f001fa4c9a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d37925a0f0594f354b06c220a1404179aa509798313bd4b6da43aacda8b6d18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01109465ba0f2c78c1d92449c93c3aa03af423e9fd17704922c0c3699cd352c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      Pathname("README").write "Testing"
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
