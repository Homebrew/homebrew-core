class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/f7/a6/2a1c5135649ba35aad47a5c31f3176e6a0ca00b87948b6f94c195fe3ac6f/coconut-2.1.0.tar.gz"
  sha256 "49d21cc6990456bf4030b55457997a2ce854502712768491fba3ad75eda2f143"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25f2e435c4a7d1be3a3bebe31529d0cc2bd9c68c5e9a60d39e0ccdf056bb13f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baaf35a4f2d084923d6f507cd9c62c6a6994b31fbdb7d0a9878ababa28458214"
    sha256 cellar: :any_skip_relocation, monterey:       "4f78230cd9b620b40bf8f6b206abc64bbf7dd8361a03563bbbc39f489c667ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "58f5492f1fc52d9c8921d8c6b0ee175fb460eb8cd2675f773f97f064b8a1011a"
    sha256 cellar: :any_skip_relocation, catalina:       "7352886fda6864b70fca74d975317cbf3abd313588f3e4fd0aae0c4b3a9ce0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd8ae6383849fc14f1ba089a05d7d40e447bfa3a5759dd0f82395715efee10c"
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
