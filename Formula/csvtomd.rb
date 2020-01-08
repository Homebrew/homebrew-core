class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 5

  bottle do
    cellar :any_skip_relocation
    sha256 "afbc8082fa52c379c904aba4ad436a492bf7568421add34fbceb3fb4cc72790b" => :catalina
    sha256 "be1e107cde89a22f8c1716b4cfa3e31b3009b6c7d5b79293e378e386dfbd2d80" => :mojave
    sha256 "70df513c26a7973a3475c3be18c332be4908374a747cec08e305c31656df01d6" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<~EOS
      column 1,column 2
      hello,world
    EOS
    markdown = <<~EOS.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end
