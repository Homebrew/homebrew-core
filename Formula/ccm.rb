class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/riptano/ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/riptano/ccm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45ac185889236c6e015b5d6ee6dbba807030325eeb95d69afc4ec4dda097d711"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65ba85b68edb0a475256cdf26c1547114ab5a43fe5bba5b649043a59a056e8b5"
    sha256 cellar: :any_skip_relocation, monterey:       "c6037bb6fad6e13326ce2fb2f08a299c549b53cd3785b490d48ef65a64adb7df"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f00c799519b01648a788a14d5b9eaaee4660b4283b91fb3159171ceaa838e3a"
    sha256 cellar: :any_skip_relocation, catalina:       "0b816ec6ead745374dd7afd75f7658b299b82616ce766f7d65249c52ffd2699e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae80a7c1a071309c01de99d929e68b38c969efc884dbbac25da2ff6fb6e8b162"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/af/aa/3d3a6dae349d4f9b69d37e6f3f8b8ef286a06005aa312f0a3dc7af0eb556/cassandra-driver-3.25.0.tar.gz"
    sha256 "8ad7d7c090eb1cac6110b3bfc1fd2d334ac62f415aac09350ebb8d241b7aa7ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
