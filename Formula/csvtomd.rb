class Csvtomd < Formula
  include Language::Python::Virtualenv

  desc "CSV to Markdown table converter"
  homepage "https://github.com/mplewis/csvtomd"
  url "https://files.pythonhosted.org/packages/2f/41/289bedde7fb32d817d5802eff68b99546842cb34df840665ec39b363f258/csvtomd-0.2.1.tar.gz"
  sha256 "d9fdf166c3c299ad5800b3cb1661f223b98237f38f22e9d253d45d321f70ec72"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "9fae1c89737482983f6f39faf3dc0cf094675aba5d4fbb2611ccd9fe44c5431b" => :high_sierra
    sha256 "867d4c8da05e61b41ca34dfff6d88ccd5f918c9b78127d1f044b3aade674a74c" => :sierra
    sha256 "61e3ccbc346862776cade070f07e333ed220a0159f01243341c596ed2f775741" => :el_capitan
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
