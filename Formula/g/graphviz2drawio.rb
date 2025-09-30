class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/fb/e9/2ba4114579f8e708b6b5d671afe355c9b8cdd52b15a9d126ec188a2bcad6/graphviz2drawio-1.1.0.tar.gz"
  sha256 "8758b9eefbac5d8c03a0358c0158845235c9c3caa99887f0f6026cfecc2895f2"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "066b2249697049321616006afa5a0f0014f0af66993d7e3a85abffe94ab85b30"
    sha256 cellar: :any,                 arm64_sequoia: "2fe8dcf491fc333babb0bc4b24aa6485b1d60245aa0b61d7aa65013be4bc813a"
    sha256 cellar: :any,                 arm64_sonoma:  "567390b769236d110cd932fa10f800a10bd8427c2ee1119d8eb039ee0c013ff6"
    sha256 cellar: :any,                 sonoma:        "82948bb320565aadc91e341512aee3d985eecdc305d413180751249bee2b414e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6aa1274f8e7fe34480578015201845f5bd4b963c3544063dc28d1e9a33c549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b271a3046503c0c35311eeeef62da8bf193834407842c44880628a7abce506"
  end

  depends_on "graphviz"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/d6/de/c9dbb741a2e0e657147c6125699e4a2a3b9003840fed62528e17c87c0989/puremagic-1.29.tar.gz"
    sha256 "67c115db3f63d43b13433860917b11e2b767e5eaec696a491be2fb544f224f7a"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/33/a0/4983cdedf62c3a1dd42b698813312fc51dd159983333fce9ec4189cd83a9/svg.path-6.3.tar.gz"
    sha256 "e937740a316a7fec86acd217ab6226e112f51328078524126bb7ea9dbe7b1ade"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
