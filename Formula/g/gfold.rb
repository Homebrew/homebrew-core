class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/2025.12.0.tar.gz"
  sha256 "cead84f83c6bd333f5c11a714db2f187150c5d7b5d1b29cd6441172195728f45"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b169463826c6f1c2198d6d189f165f603c214d428b236921a01891ba7eaa9369"
    sha256 cellar: :any,                 arm64_sequoia: "e9df0ea149ed3b6eaac544266d9ddf867a482ff03a6e347771a1fbf5a5ec21b4"
    sha256 cellar: :any,                 arm64_sonoma:  "c44f90438bee0efdf92767d2f10cc3bbf50e5fc3d2c78b4b26c2f28fa4e52efd"
    sha256 cellar: :any,                 sonoma:        "e82a9e593da89543e433c6a6deac44cbb06c7e322f1b8a7ffacc7d9c9b49d812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79f7422c37ee4b9afc3294589753e6b48038f27d37e44a5237de501d36d6ebed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74fb427b9eab422ec4539ef4821bc16f1b27797c6f9b67c8a8e3d00c9177ef5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    rm ".cargo/config.toml" # avoid using mold linker on Linux

    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "gfold")
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
    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"gfold", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
