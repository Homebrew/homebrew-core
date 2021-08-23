class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.5.3",
      revision: "12e0f0d1a5fb258f2f413a493520b6f5db479444"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "55c991a17bc7b077c002db88cc5e5054ccda85f685fbddf906738264b00f0c6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "bcbca3083026bb817b4349f8aabb0297e8775e0f4741141b8b2a2a7f51d8ab27"
    sha256 cellar: :any_skip_relocation, catalina:      "aa1069f13b62a799375e3c3f3bee876553fab068551e27c8609e1bea4cc2c51b"
    sha256 cellar: :any_skip_relocation, mojave:        "202f8e4ab4eb5c34f42b26f7f2b99461ea2d858dea1cb9ea71f972e5bda3f712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb34877a7cc9385fa99b27542e66433e581414df53d690443448129661b76d0"
  end

  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
