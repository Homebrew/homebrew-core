class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8e19ecc0c7461e9a09108fa80379172b9cfe8644871197e418ab78cc65734b60"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "731a2c48230821215f98badf23833cb0c598bfe2c58b2ea8c2bb7f6c2f27f1f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d766676be9f3d581ffa53ddfde4ae2fec314de2df354dfe12abaa1a656a847c8"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f41b41b43c930d19b775a92ad1a69c12651c0d871f277852540912d42946ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c19f286ae0f6efeaaaf7df7c8c646036ffcc27f97c23268bb5c4ec0c8007e3d7"
    sha256 cellar: :any_skip_relocation, catalina:       "9dbaaa7dd054c18b1288d10582ae8d534acc5153ac2fc6ca9dccee1ca3b1897e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495bf66751a2115e647d6da227ddc092f5768823d174c555d86a34111e9cc5a7"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
