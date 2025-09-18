class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/refs/tags/1.0.18.tar.gz"
  sha256 "36861161513c508c0589014510cdafd940a6e661e517022a3bea48ecf8d5fac4"
  license "GPL-3.0-or-later"
  head "https://github.com/visit1985/mdp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1427d8626e29d6015170cc1f80d049e4c4f4b4ea04a92e510696b93c1f22a1e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39469240d3ad1bb651898e75c310a229cd6492cc7e66ba7f24ece8d9aeda7f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829d971b7d1942ec34ea4c7b948ccd0a988e6fb5618091919785e9e124c10bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b1be7a64cd13ff001ee2b58385424e3e35f7210eb0f9777d401dcba321d86f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb2933d0f75d822eed5ff6f6dffeaaed000ea28737369f90cf234e8e7c296cec"
    sha256 cellar: :any_skip_relocation, ventura:       "d0b783018115ca2fd3f6dd40b909ecd603d2c22dffa0a1cd48d1a833a284e345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92778dc9a394d2395627091c21f3f51cd1afa7431a2eb1e1d836b12e2f9e83e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8027ddc1b08d523ff38474c5f95ae518d39900afd5ca57a800c1f34c1d064ae"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
