class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.4.1.tar.gz"
  sha256 "bdcbebd543f7222e253e4324677a5c524f90543cbf859a448359ac426b9453d9"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "60e83410cdd305ee8696a31edde64ab86770a3cf68ac24d9e32323699554b6b4"
    sha256 cellar: :any,                 arm64_ventura:  "4e55b07619facfe9f0f610613cf690787eca71c05b938a7b8d7451e516adb768"
    sha256 cellar: :any,                 arm64_monterey: "ba0e3c374183fc5a9cb6d23c5033c5445e33cdc41a2a7b0d071ed58116906381"
    sha256 cellar: :any,                 sonoma:         "a9c83046b56ab7e0948e5d54c6705eafd73d4000e294be5ccab9f987a52a4d43"
    sha256 cellar: :any,                 ventura:        "08d4b28d38323c445deea7c5e67eecd8c2e7bf0c81f20c5eb0a7dec1dc1713f6"
    sha256 cellar: :any,                 monterey:       "e7d97f4db17eb4f5b2ebace9124c0268bfbfcb75fd83d8655b373a24cdeefb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf60815db0ec9cbb2daa8b67b688a40d873263937a5e09099e45059aab82341c"
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
