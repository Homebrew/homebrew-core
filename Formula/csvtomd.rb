class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "a5bddc4b8736fa0045b6eecf20182cf00feb4eea6502ebd2047807852061f9f3" => :high_sierra
    sha256 "6b87f6a4094884349722fe7480b8bf7b244f6e4cb75da85f58db28f10bd6f75b" => :sierra
    sha256 "fc233ab99bed5dcd853a3a15ff38e607694187acd6ed9be070ce7c7a25eb0434" => :el_capitan
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
