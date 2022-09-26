class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/41/9d/62a756d0b68ce9dc09afae42249042879d7a3746fc3b55550770de68114e/coconut-2.0.0.tar.gz"
  sha256 "a0b05cef7eca57cd21070fa9f3c8a80303ef5c7ef35d7cd7abdaf02f0ea8e5ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175ba537a78b60af0fbdb5d34cf094d3e1c8fbc7325015cad49457246f03d117"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1bac0a20ff53c65c807a39407518bae4e93aa18d5751639e3d0ac8af2eb43d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0f42ba0b0c18e27d2a1aa03f78f52cda15180af48937e5c87039e24a7de98e62"
    sha256 cellar: :any_skip_relocation, big_sur:        "91b29d721725e33a4caa5a918691bfdf88cbd5f7179f63060d70ef50449e7fc9"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf64c77471c9e1021f76f5429213a65880f2065ec2ced64131478015eaf9d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4322eaad03c1737c8f0988c3f9778b5d23a2603defd711caca2ae40660a64c3c"
  end

  depends_on "python@3.10"

  resource "cPyparsing" do
    url "https://files.pythonhosted.org/packages/a9/70/b40155e3dc29492a5c3e3bdb8650164816dc112417cf9d56313ba9ce8b41/cPyparsing-2.4.7.1.1.0.tar.gz"
    sha256 "c533dcc81ef855e46a741e552a6f5a30b7aa7af417313cc8d4ea077034abdd77"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
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
