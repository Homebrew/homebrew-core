class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/cc/a7/49b6d5a7b67ec52cd9932c36bc064988673c913a94e88304e533cf2c1396/coconut-2.2.0.tar.gz"
  sha256 "1651c15945e21cf9b4e0e2712e9effdca54fdc5945f62f99712db16f04391891"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ccdba9ce83f347a3ae8a6d0e1e837f1525c1bd035e6e35cf31cd59fa54f9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5094974db4f73a4c2f9e68b6fa8f4768a84b90967e7137d80ff226ad04ff65a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38d9677981288784d7d8b9d78d78100263a359602c3ccf435406b6926faece3a"
    sha256 cellar: :any_skip_relocation, ventura:        "104919aa3b1e68cb13242001a67792046349e4121aaf9cd6175a629ff0373726"
    sha256 cellar: :any_skip_relocation, monterey:       "93cc736e5b7a77166f862c9cea8895ed002707be19150511423d70f772e781c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e94622a988049042dd04719ae4ca0bc51789c904d9926ef854fd3b223735105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde3be5ad7d86ea8157246363f4e55c79b5bd3e58b2afa54023cebd02293740f"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/c6/6a/b37f4aff8f53083fe71e9b5088dd3a413c231ece8dcb0809a8f2c2b5083e/cPyparsing-2.4.7.1.2.0.tar.gz"
    sha256 "c0dc51c5dbb6d5c1e672a60eb040b81dbebbab22b8560d026d9caebeb4dd8a56"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
