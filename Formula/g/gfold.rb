class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/2025.9.0.tar.gz"
  sha256 "6c4148872a59afb26c1c6b35357e20f71846ef01c6871e3b3f029bd62de6ad33"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "edb92b276fe6bee0afef62db2bb2305a54b9378017f9a2f432e02daf9a76ffa5"
    sha256 cellar: :any,                 arm64_sequoia: "f4031f3fefd8321d75fb018bee1e0f29eedacf367a2e9fef3b765e06f28d24a9"
    sha256 cellar: :any,                 arm64_sonoma:  "68142e20bdc61829c8c077354b9095fcefa3ffc50a5bffce38c70a101d9ba3f3"
    sha256 cellar: :any,                 arm64_ventura: "b0da70d0850b51b5247724228907cc8d5a33a0ada55836f02bb8f784ab022f06"
    sha256 cellar: :any,                 sonoma:        "d6e4849bc035da07477b8f3fe9a3b2f933115a32af11068913bfbb48a63019e1"
    sha256 cellar: :any,                 ventura:       "f4e511851f69ced100c4fbbd04d14a904934d7a5dda10ba014f71bdb944ed8eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9dee65d0868f34b2398f9146b6345b85ba7e3c72359b7453ea8b37104270577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea333ab8e12a20296c855b8bcd5844fc728f299263140f4b81e29f9a7cbf7457"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    rm ".cargo/config.toml" # avoid using mold linker on Linux

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
    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"gfold", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
