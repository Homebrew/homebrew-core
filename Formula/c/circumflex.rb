class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.3.1.tar.gz"
  sha256 "949dde816b75b85ec48bb0158931d540f6bc07606d92f441881201d4b8680a49"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19bbbe0c0d13ec6f4d55ee419289df13bc579bb5841bb4b439598ff2790ee25d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0528b7d4ff715f11668190ff79a44b7973eccdaf899476dfad176ef54698e857"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d96405d7a881c70b712e4f885624e211042d2aefe3d7923b1c6c49209dd2c68"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c2833d76bac0fb21005c6f1c7b4eac2fc57785f957b99656226ef9f1a8ac812"
    sha256 cellar: :any_skip_relocation, ventura:        "4ff94d971380c1227b1a9be3567426ee1224c91a7eedb1fc42a614b1d29efe61"
    sha256 cellar: :any_skip_relocation, monterey:       "7c9b0d7864a60e71089521499c162d6104d92d5efcefbb2d31fa497eb8e4ed8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d9cd936031fdf86b2e778efefc6e4ec6418914c49be817c5feaff51fd837a02"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx article 1")
  end
end
