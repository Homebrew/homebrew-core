class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.3.2.tar.gz"
  sha256 "95b3694f4906f737447a787e2d367ae74cf97f27f74150312bcfb1381badb3cf"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f193e526daa6a3d3f7785018e13b7634d53b41aaaf0a1cf983f9c2ebcaf992b3"
    sha256 cellar: :any,                 arm64_monterey: "dcb81bf8ed789456810d7e63e014f8a4cb0f6c178329351ff2fc072ad22bdd3e"
    sha256 cellar: :any,                 arm64_big_sur:  "93aab312ef8a1bf53044f4dde89a33c54d07180f6c1f8784c154d858400c3484"
    sha256 cellar: :any,                 ventura:        "53d22eab5499f6ee9048211817de6ba8d19ed0d36310df33fd9efb7728b2de7f"
    sha256 cellar: :any,                 monterey:       "2ab7117ac324b40dd2bba7218f5961a26e3589cd5a31777971eff10f27edec2a"
    sha256 cellar: :any,                 big_sur:        "29b8f4ff9f7879e3cae6aff89eaf1a80992dd8dbff5e7f9c41e9c5b73ffb90d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c09f89c69fa031e2a26d9f8e0bf5e50ff4cdc4aa125d0c1d590c64b92801edaf"
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
