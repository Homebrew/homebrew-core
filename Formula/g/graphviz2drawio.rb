class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/fb/e9/2ba4114579f8e708b6b5d671afe355c9b8cdd52b15a9d126ec188a2bcad6/graphviz2drawio-1.1.0.tar.gz"
  sha256 "8758b9eefbac5d8c03a0358c0158845235c9c3caa99887f0f6026cfecc2895f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4769c040786fa9ee30174d92bb67b3a953a2f2326246f8b27e654bee67d200b"
    sha256 cellar: :any,                 arm64_sonoma:  "e4c6965b0583bac104b5bd23840b5d54ad024cb9e1f85edda82054af89ab57da"
    sha256 cellar: :any,                 arm64_ventura: "1a176afc58d98042fe8703e7a77394312c968a24ec8030e31818a806f9cc97c2"
    sha256 cellar: :any,                 sonoma:        "2c5c640eb65fcf872c3b2040e66d4e50638d2d20b86875396b1be23077aa7057"
    sha256 cellar: :any,                 ventura:       "c40142532b84851304ad59b84766b4925e235dc7be8c59101ac4ee510ba2a983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05eb5f23dc6efa81762509793f4592d02c8bdc07f1c0b8ea7b24c93ba1a8f782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de7b9131747446df4db4a90e800749c21e78e715fb2f0843a7fe847978b2c05"
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
