class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "362ac1ff6da00b1e5c1ab68614753fb5ffff3f1860a9a8272bf067cd8a9edccc"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d925d16450b292ccdc395d14ada3fb7b31e0e68371167ff39dabb1bc6b85750c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "203a2d9ea729f13e90154956c084168da301e57813deeceb8af67c6f6957e929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f06b8290faadf47b19c6fb823dffc00d4cae17847ae15e129c4d6765c5644e"
    sha256 cellar: :any_skip_relocation, monterey:       "380046b597b6f6313165086ab3293083903cc475d9a07580acedba80ce165110"
    sha256 cellar: :any_skip_relocation, big_sur:        "156407961ac7e41675997cabc01abd6f580ebda82141d08686a78c12d675adc3"
    sha256 cellar: :any_skip_relocation, catalina:       "9b5b0bb9f8f8d381e77ef99a88ae388779c419c85faaf6eb575a860bcec2707f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce0165197dc97ae9de900af63953ad42162539773b62c6398ae9fd7cdee21467"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "git-branchless")
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip
  end
end
