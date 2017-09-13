class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"

  bottle do
    sha256 "1ef512bf336e6c7b28daa12940fdcdd3c04961d91b5a1545202d71211dce79b0" => :sierra
    sha256 "3405adf42dc819b85088379ff63a55d8247895c3d9ac2d9e227b3d23e375f349" => :el_capitan
    sha256 "fdadfc84d81fc3a934ee2d9ecf2bd0fecc35a88cc0051ffbd60437a37f652b86" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      column 1,column 2
      hello,world
    EOS
    markdown = <<-EOS.undent.strip
      column 1  |  column 2
      ----------|----------
      hello     |  world
    EOS
    assert_equal markdown, shell_output("#{bin}/csvtomd test.csv").strip
  end
end
