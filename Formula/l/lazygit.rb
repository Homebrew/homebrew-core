class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "a9dad9e5bc9edb1111b3331d1ccb25f97f2593f51b1557a36c1765df08cb3006"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d046877e0bc378a0925d06511fbaa6248757429574d286abe5fd51c4383f6b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee306c2a63eaf6b4e91ab839218d4ce8c40a44fc2817061829b4740c00787625"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ddce43fd65e9b0bd5cf9ed813b06e20fcff3e9aba72d9f513095e892c193fb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "20db4312183b643da7c97b44bad07fe5a52f2c5cdfe2f6a2abcbcbb5e9e7ed83"
    sha256 cellar: :any_skip_relocation, ventura:        "d1fb08bd417529a94039003fbe29d91ba2050dc33745402f616a98c6c566031e"
    sha256 cellar: :any_skip_relocation, monterey:       "1789abe1d2497e77541da89006f548e6a493c7ff0168e7e163f1c8c60b4c0017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46f260535e1e9616a985a9e36ef74f586ff2ba8fdd13a849cde63b92263c1c1d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
