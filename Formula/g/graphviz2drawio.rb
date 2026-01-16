class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/fb/e9/2ba4114579f8e708b6b5d671afe355c9b8cdd52b15a9d126ec188a2bcad6/graphviz2drawio-1.1.0.tar.gz"
  sha256 "8758b9eefbac5d8c03a0358c0158845235c9c3caa99887f0f6026cfecc2895f2"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "954e1640d40392d3125956c08981e7899624b6e24b114bfc704b8fc4a5e0191a"
    sha256 cellar: :any,                 arm64_sequoia: "499ba9aeb4254b8717dfbbb9fd64517cba80755f448e013e18311d55b636f683"
    sha256 cellar: :any,                 arm64_sonoma:  "bf32769540b693e9d425c30c065b88b30d3e1169d18c6270a7fd17e1ba6169d0"
    sha256 cellar: :any,                 sonoma:        "50ffcd094a34c8ed5b05038c3bc068f0b14c01e7d2c82e28fc7f48bacf04bf9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8bbabc5e86b17bf857aaa590244513757a9888a65da4186a29e7b00d74b4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680c4fc4b3f8c9ee6fa2fcb74236d86a4bff8d69098bd68fa34d41c7bf9c5704"
  end

  depends_on "graphviz"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "svg-path" do
    url "https://files.pythonhosted.org/packages/66/b9/649abbe870842c185b12920e937e9b95d4c2b18de50af98d2c140df3e179/svg_path-7.0.tar.gz"
    sha256 "9037486957cb1dcf4375ef42206499a47c111b8ffcbac6e3e55f9d079d875bb0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "mxCell id=\"node1\"", pipe_output(bin/"graphviz2drawio", "digraph { a -> b }")

    assert_match version.to_s, shell_output("#{bin}/graphviz2drawio --version")
  end
end
