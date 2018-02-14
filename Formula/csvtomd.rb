class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9798a11d45bc49d35e9d0cadc43f67f0fab0303381421063721f80223acc84fc" => :high_sierra
    sha256 "93644a15d58ab235eec9ef98f2ae23890ff811756fdba8870327b3d2b474cc72" => :sierra
    sha256 "95e1e0ae2ba1fa1205a19822b5b79b2586ba9f36bf9fed7faf30e1a4223f27c6" => :el_capitan
  end

  depends_on "python3"

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
