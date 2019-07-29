class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "4ca9e89b41c681120bdf0900fbf5833463115b8d5373a64227ba61ceb252cfef" => :mojave
    sha256 "9676da327548cff3c4e1235b7d9071939315b22f8a7fcce3c555b308890b8338" => :high_sierra
    sha256 "b38719288a0ba84c2a2143ac0f13965eac1f796e2a6ab20918fc59d304415f2b" => :sierra
    sha256 "d343b9087bbaf2b5a5be09f71d23ff9b07742cc262f5fd66b7b220d2db73b4b2" => :el_capitan
  end

  depends_on "python"

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
