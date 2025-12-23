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
    sha256 cellar: :any,                 arm64_tahoe:   "2160495230c8aaaab86c0824b90b25fd2a3a0136379574d6342094ab74faf8eb"
    sha256 cellar: :any,                 arm64_sequoia: "bbe23637981edcb00b103bb7579b4ef704a3e8c69b735a5b36e1f05b7051c2a8"
    sha256 cellar: :any,                 arm64_sonoma:  "ca6d77140523b015770a808845909dabc4a3e7d2a762d00fb71451ab348861a3"
    sha256 cellar: :any,                 sonoma:        "bd97b1bc30d59f8dfe4f4748d6c5e486316efa79c0548ec67b3e605f0e089308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da66c27309f1d9fa52f603e39365e0eaafd9a3c07e01aae3ee409b7b96f3792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a285553c05349ac0c0324569098dc9750240955669464421c4fe875c9e7683"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

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
