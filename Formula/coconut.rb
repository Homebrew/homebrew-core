class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/3a/85/7697306188fc03809e794a65a2a745fdde052065b83571bdc36de7fe5a77/coconut-1.5.0.tar.gz"
  sha256 "cb2263fb9e1aa4c6bb7e3051ae26e1444297ecc5e8762c4f8547873b6a0d861d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f8af4316f6f4399612f94264b0c5d2fdce2dc31c4ad819dbbc5f6105205ca5f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0e394fea611ba1009e0293aac3331e6febf36cbf8d19a7cf70a1778d41675ad"
    sha256 cellar: :any_skip_relocation, catalina:      "8493aee08ef8583cade557c928736c7a61b309d0104d34e6d36382a0b02e6b93"
    sha256 cellar: :any_skip_relocation, mojave:        "b4bf84959c2a863d3ce207c2f6396dcdaa0aad46e8f4b4970fda38e0c9113bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422ba0982b614659cf058c36636310ac212cfde871f7e1befe51f8efc18eccfb"
  end

  depends_on "python@3.10"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/7e/08/00b11cc1c195301e5c9710b399a769e18fb6c7f8082b4f49c1aec78023eb/cPyparsing-2.4.5.0.1.2.tar.gz"
    sha256 "689b6d53f85bef876fdb07829393bbbed66d2fada176a9386800dc49e4251b46"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b1/32/2a6b734dc25b249467bfc1d844b077a252ea393d1b90733f4e899aa56506/prompt_toolkit-3.0.16.tar.gz"
    sha256 "0fa02fa80363844a4ab4b8d6891f62dd0645ba672723130423ca4037b80c1974"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
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
