class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/2026.9.0.tar.gz"
  sha256 "d5bc582d8cd9c2f05097f6e7669f166ded64a0108373e75bbd864e3f6e63997b"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72fb93ab699ddb00c33ac819e0e36e382fafd0889994732aaf27f11d98a18ccc"
    sha256 cellar: :any, arm64_tahoe:       "0362e3af27dd1b571e1b14d12941fb320ccebad49f8dc97f1ef43c8267e21476"
    sha256 cellar: :any, arm64_sequoia:     "75f8f681479f82cdd5456e704049a12cff6757d13e01113b9a3586729685644c"
    sha256 cellar: :any, arm64_linux:       "d39aa66963eefff24fb652de6baaf8c1e0753ca4523c3aaed972beb901d88e77"
    sha256 cellar: :any, x86_64_linux:      "99bbea5976d834dbad56ffc5aa7ca56381b3048da5887d8d95251107aa24c91b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    rm ".cargo/config.toml" # avoid using mold linker on Linux

    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "test" do
      system "git", "init", "--initial-branch", "master"
      Pathname("README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}/gfold #{testpath} 2>&1")
    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    require "utils/linkage"
    library = formula_opt_lib("libgit2")/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"gfold", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
