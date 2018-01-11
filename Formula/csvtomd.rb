class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f53846339d36bb6381c64cf3ddbb8a9f35e18776d9d72470a42c56975694c01e" => :high_sierra
    sha256 "34a901b114a823529e064907bed930ec73f0d99c61e4095891ac4ca78dfb6345" => :sierra
    sha256 "9a44ba7a6997455ee808f504586b926b1a5b0f8fc26775ca5d6d75172cd64960" => :el_capitan
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
