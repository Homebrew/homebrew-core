class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/2026.3.0.tar.gz"
  sha256 "e8e0667c324658c0c816c909e880879f606ca7d874b7cbf4820ef47ba517d558"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db41a670045dc8a7876c729a952d1fba166f287eea7024b8719588f1da51e871"
    sha256 cellar: :any,                 arm64_sequoia: "6ef51773366e7661f85473c36fce2dfea09653ae56caa817e0d5c83aaa25dc45"
    sha256 cellar: :any,                 arm64_sonoma:  "4ede65914fa3dd5b43f7e247f74bcd091962e101e9f72b8d9af12b4dd13cc5d0"
    sha256 cellar: :any,                 sonoma:        "528334f580d8869521b1b1d0ee3b8cd282c191f350596d77c49acef16a31d7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5907c31d6a83a8ec8f14c3aae1d282bd2bcb1d279532f7503562e9e232f90276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd6dcad1f035d6dd3652a9a9ced56e2212a155a4428008e7cc09b4953fde63f"
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
