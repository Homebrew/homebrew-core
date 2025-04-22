class Graphviz2drawio < Formula
  include Language::Python::Virtualenv

  desc "Convert graphviz (dot) files into draw.io / lucid (mxGraph) format"
  homepage "https://github.com/hbmartin/graphviz2drawio/"
  url "https://files.pythonhosted.org/packages/2d/c5/bb43966bc97368fc7eed9d8a79f0bc7eba8484cf6066f687720b616e957a/graphviz2drawio-1.0.0.tar.gz"
  sha256 "5409f11cd080b28d77408817559b6481250b3053cec757ab933b92b3075606a5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a823fd2862aebc1b5de5a9d108b59967fbcde502a7af913534e7d19efd7ce6e0"
    sha256 cellar: :any,                 arm64_sonoma:  "1434e458a308fd5f985e4f6c4f07a4c9990e96cfcba5b5d75b914f716e118560"
    sha256 cellar: :any,                 arm64_ventura: "fbe3fdff2d2aa5347c017f76fdbabedd6e186193a6ecfb1d89c3096282f0eb28"
    sha256 cellar: :any,                 sonoma:        "2ef4e26ca63cd22697f16a72f10b049f6a3a4af8a9476bca63aec0b343208982"
    sha256 cellar: :any,                 ventura:       "e95abf496b968b6720ac814b150f9f43ebcd2ce510f3415b6e304e375aa1c488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3e5d4d939d4ec4ef712211f3c4fa83fc3829f2dd199aa79ca638978e2cc746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3027d0a7344e41bab4006f7c3f422fa68dcafa519735e53a7165378f0c3e76"
  end

  depends_on "graphviz"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/09/2d/40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954d/puremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
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
