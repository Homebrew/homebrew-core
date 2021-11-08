class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/5f/71/2dff89b35da1c502c9f48c40e4aa1e0d5dfe7091c907b7eadd93371120d0/coconut-1.6.0.tar.gz"
  sha256 "1f8d3ba15a4335246dc5c2ae3693042b9ce02398455fea5fc6d1d9dcc242c69b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad32912df49fd08bfa27f17be482b60d15ab0347a8185026cc7ff2a4b4a395f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8af4316f6f4399612f94264b0c5d2fdce2dc31c4ad819dbbc5f6105205ca5f7"
    sha256 cellar: :any_skip_relocation, monterey:       "34217356edf4ab9c8dc518c3d00df35bbd592389648b9a4cd0fdaaa834befa8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e394fea611ba1009e0293aac3331e6febf36cbf8d19a7cf70a1778d41675ad"
    sha256 cellar: :any_skip_relocation, catalina:       "8493aee08ef8583cade557c928736c7a61b309d0104d34e6d36382a0b02e6b93"
    sha256 cellar: :any_skip_relocation, mojave:         "b4bf84959c2a863d3ce207c2f6396dcdaa0aad46e8f4b4970fda38e0c9113bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422ba0982b614659cf058c36636310ac212cfde871f7e1befe51f8efc18eccfb"
  end

  depends_on "python@3.10"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/5c/4b/37d7dbafb2caa565fc3343dd7c0a5f5830f63c2427411c7c0dbc91109391/cPyparsing-2.4.7.1.0.0.tar.gz"
    sha256 "8b031074b684ed1274d7f048e7e9645e48d2ba5540c31ddf521bfdce79f2f6bf"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/53/96/b3bff620964869c07252fc2eac4e7e2dd48aea07314d932d21cfd92428da/prompt_toolkit-3.0.22.tar.gz"
    sha256 "449f333dd120bd01f5d296a8ce1452114ba3a71fae7288d2f0ae2c918764fa72"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
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
