class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/f7/a6/2a1c5135649ba35aad47a5c31f3176e6a0ca00b87948b6f94c195fe3ac6f/coconut-2.1.0.tar.gz"
  sha256 "49d21cc6990456bf4030b55457997a2ce854502712768491fba3ad75eda2f143"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5988163c09431b70f1699df1dfc7ed64a6d32c4e6f2b421d456301895df8ddd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19fde8c5082e84bfed002ffcc8b703c3deda5921523d0583253b6b5ee5f8542f"
    sha256 cellar: :any_skip_relocation, monterey:       "9530c8f5a984e194148680a29111f8c221c45d8586f526e23b2df5e22321cedc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0d228e998ca71a81b9455b5b835e043255a248026530ef0789714b0951cd4b1"
    sha256 cellar: :any_skip_relocation, catalina:       "250b2b44bc0cf06d8a554908c2bed55724d73fb010ee0202dcb63432c61c875c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1924df1161f6df47683082307688ddc07a05d67205ca57b0c81accb0d093e299"
  end

  depends_on "pygments"
  depends_on "python@3.10"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/c6/6a/b37f4aff8f53083fe71e9b5088dd3a413c231ece8dcb0809a8f2c2b5083e/cPyparsing-2.4.7.1.2.0.tar.gz"
    sha256 "c0dc51c5dbb6d5c1e672a60eb040b81dbebbab22b8560d026d9caebeb4dd8a56"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
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
