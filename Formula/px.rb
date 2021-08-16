class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.5.1",
      revision: "807686e17569f4f899292de03a0cde226599cf04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e371539128e7f622e4218398827654cd8db94b1886b26be9e892fd426d266851"
    sha256 cellar: :any_skip_relocation, big_sur:       "1357231e8c68afdc8e423dd0b202d173fd8b4c15ff50faea27fbff3d0b2aa01e"
    sha256 cellar: :any_skip_relocation, catalina:      "74df4864ecc50eb4c6497d798c2afb5d30b04ad7a70c5c6f253fb11ea46fa138"
    sha256 cellar: :any_skip_relocation, mojave:        "3bbae0d9a3f020663525a71eb5083445c61934de670b0f3686e9891bade5f74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "081c0c5b4ba615b4ee6172744afc63c7ed5229aaeca4c22a255bb8d8b3ee1594"
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
