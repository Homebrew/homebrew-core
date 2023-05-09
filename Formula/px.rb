class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.3.0",
      revision: "2a870a22ee3d6b952d5aa90acd18caab5f6ce91c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11617f1510ad69d0e6d8ef4b8b6193b89f3fc9f41711a8aa8b3ac899dbb8e68f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc068dab7c90b25bbfbbd2d941c96812943184cb4a1f663f88127b2fc5cf5d6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d651c79ac931aa209864e2739088cd181bd8b0ecb27922165099fb03d5ab97d"
    sha256 cellar: :any_skip_relocation, ventura:        "032215b142845175119f37b6a23c886bea978eacbc774cfabeb8c6c9512ef0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "a747b10d8d6fbd8976555a237766f02da3d6eb0367a0b457f8bca21d2b45d3f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "faf39c160c1b707907d565724674e3d0c1587ef1ca0b24ecc448be8ae5fc07d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67fc30475d52901b3a3ab8a1934bcb2f688d9fe8df6722a9534428b20102525b"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
