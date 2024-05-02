class Netaddr < Formula
  include Language::Python::Virtualenv

  desc "Network address manipulation library"
  homepage "https://netaddr.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/e6/0308695af3bd001c7ce503b3a8628a001841fe1def19374c06d4bce9089b/netaddr-1.2.1.tar.gz"
  sha256 "6eb8fedf0412c6d294d06885c110de945cf4d22d2b510d0404f4e06950857987"
  license "BSD-3-Clause"
  head "https://github.com/netaddr/netaddr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25624efaf7c4221935d4e3362289dbbc46e63883cf39125981b597a377aa2877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "573546a88ba3570e62d95a7036c4ad331e93e540d44987837aa1c07e2699ab76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "471c52cf3a2dbc169dc4891fe75dc0e39e5c7b4c529dfef4b1bb9209bf19e4c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c209297c2495c4df58e9b167bde9429d0bcfe632e686dd9f515e4ac5e4d676b"
    sha256 cellar: :any_skip_relocation, ventura:        "28191e21062e7687d22fdf5bad7626dd9725c56d320be03a0454112148e839ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d9a436fc2e6691d867109e3430920848eba5c0f2f7686cacb4e6be926cbc7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ac74b7d51ebb9194cd35950a52394d4d484f7ed0a2e84618c8cfc2628da800"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output(bin/"netaddr info 10.0.0.0/16")
    assert_match "Usable addresses         65534", output
  end
end
