class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "f28e280c01abb11aa9ff5ae7a35df3e9822fd37a013b6c1d79d1453a5f21f5ad"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4beb37418a193d3c1ba15dd1eea0c7243b5f7d6a4a2ced6cc9495e82c69f6a91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b6ab2559e1d0322a182f11c4a41e19e3fde5475a1d7ad1ead816aa366f7df0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e523fd76505441f4536a3a9331eaab23e83f5ace7d37dbfd5f6f73c78ba33702"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19dccf92346cb645424a2d5d678189cce7a51705a0218ed893c88a75324e5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d5c11cbb5ab6683dd3ede34c25e30e61a95e23a078c6a34df1aa770050509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68295af29ac3b898d2cf2bf4bcb45e57396da80b90d2ee1b6e57d55a9c54f0a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
