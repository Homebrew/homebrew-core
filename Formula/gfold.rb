class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.3.3.tar.gz"
  sha256 "27f99702221229dfce343c6aa2d80105fdad24f200628c36005d51cbb6242b04"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c303cd443586ad57a7a02ebd07efc88e12cc2e02fa1c5b83ec9f51e0cdd21830"
    sha256 cellar: :any,                 arm64_monterey: "dbf555f733fb833945f6a3338d61080001da743696628941999c98d3d8bff1ff"
    sha256 cellar: :any,                 arm64_big_sur:  "5a0b837f7cbe091537217a5457371dbd660e49e3ea70b2cfadc6a9cd5bf3465d"
    sha256 cellar: :any,                 ventura:        "4ef464414e19b27071a36340a878e0461e38dcaf882252696fa231ff740e7b3d"
    sha256 cellar: :any,                 monterey:       "db5d7c02c13366ac3cb81540c9596813bd665bfde19b957b98acfdbc6e96443f"
    sha256 cellar: :any,                 big_sur:        "fbb261477b51b2d2a177c7d802fd637a620f733e1902f52760269ce004bc9cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a80da02ed65e6085050397801b9d6ff9a6975dbee8276b4bcd34b96ecfec8be"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/gfold")
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

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end
