class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.2.0",
      revision: "8f52d01b4077714b2234675b7e7522bb42d12d08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc0b7a64f5288972e8314c925d63f99da21dcc1951e612f192283bea40bc98e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70022f6e7caf051db9fa27b5576415fa94954554ff4d18e9b038f09c3d4ad27c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7871bb0a2d1dc89a19b59d62fb8af6ae7442db2277d2bc72d178f6f1d358c9ff"
    sha256 cellar: :any_skip_relocation, ventura:        "834810cf9aa6f34d57dfffb957939324fb1cc46720b9e284165292ffd2e70057"
    sha256 cellar: :any_skip_relocation, monterey:       "df39f38c27ebcaf0a3fb55275357c4743f6e01e5b30ab229102215c0416ea60a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a41fa8d6302b356ace6fcca3e6f5e6fa94b843fcee89bb1dd907db3f45bbed38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296612c6c22a933f19850944270315c3d32195b78c06b1c0b994563f678cc819"
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
