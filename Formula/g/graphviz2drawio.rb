class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/fb/e9/2ba4114579f8e708b6b5d671afe355c9b8cdd52b15a9d126ec188a2bcad6/graphviz2drawio-1.1.0.tar.gz"
  sha256 "8758b9eefbac5d8c03a0358c0158845235c9c3caa99887f0f6026cfecc2895f2"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50ab994e55b3da1f78154153eda00cbd046e61622a68166d91a749e9a2f14aeb"
    sha256 cellar: :any,                 arm64_sonoma:  "5308392ba34b5394e45cb88673b2ad81174c6a04c59c21a4efa60d79baf26405"
    sha256 cellar: :any,                 arm64_ventura: "682c30229b1763aacbb8c6a242ca5b8ac51911348a311eae43f7195e72f3e74e"
    sha256 cellar: :any,                 sonoma:        "f9c6d7cdef5d9589a47a6eb8973c9e8cc3183aba7c2d089475bec334e28fcb6a"
    sha256 cellar: :any,                 ventura:       "975b9d72d80c92eae4c493d6c0875124d246f9c13cdaeab176b6fec001fd354b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a0aa57fc3e29714c8561077c5cf190defe648a516b25ae95521414e1aef357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2898216e7208864eeaebf6bd70e3430ef769e6f8ca656b139a711e930984d3ec"
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
