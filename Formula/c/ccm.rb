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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4b776344544f21c1ed435bb6fbe9204b1ceff6bcd8a55153bdef9fa1e7a7c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be900b95dd8a12fc425d2c9a23b4a1e4d81fea39100373be42323a0d52981995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3724c35c53d050b014872b32999b494e78bf2e37125d74af77d2c06e87349c28"
    sha256 cellar: :any_skip_relocation, sonoma:         "77994bbe83114d1d54aae4a85afc4ffe5a653643a2a482ea9bc5ebb5ef46d222"
    sha256 cellar: :any_skip_relocation, ventura:        "87b39b4e470135d8aff191c9d9296cb46bcef172a7047f7d97e50a3b344b885d"
    sha256 cellar: :any_skip_relocation, monterey:       "22e13ceb8aa99807bcdc58a69fe92b5ee701a0d2abdb1e5e03904a99a8f6fcd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed9334e015be0e1bf2997b2908b20536fcdf68da63e5ef3125dfd270fc66feb8"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"
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
