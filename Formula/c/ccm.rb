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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caa73c15f42b4bbde8b8c8b4a8e63bc73caec21fba17f4691ed872a4ee9772a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f1195eed8bd7612ed15b923ae39ff629a43902e6b954e313d5bc8bb2bc3f56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbca70057fa9839396627d7780da959a3d017c435e9017e4a908b1a0832466aa"
    sha256 cellar: :any_skip_relocation, ventura:        "00666fc11e3498143856e368a3d0b3e78ac6e797402b601962a108254c069b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "5965d7c0684c03296b7f466a00c1cd9c0c2a5d5639aa97ea6cd9fb571e334123"
    sha256 cellar: :any_skip_relocation, big_sur:        "a18b40aee5ee0a8870a62ccedf5c8b5c2c55dc41ac907df7ff0843fc6b47fd38"
    sha256 cellar: :any_skip_relocation, catalina:       "d9f1096165bae0521103449c5c1586f945d628433d3884afaf14d23e56c25e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e9f1a5872ef6102a0f2be3e44a4badd1fe2f6dbe2ddd49ce59650a80ff93c0"
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
