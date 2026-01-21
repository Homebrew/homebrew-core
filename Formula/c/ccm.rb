class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/apache/cassandra-ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/cassandra-ccm.git", branch: "trunk"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6fbe9512a270d798879c5cc6cb046decd6985c4536d491224f99497059e227c2"
    sha256 cellar: :any,                 arm64_sequoia: "6432c47b854ccce393f4f2f66cfb65f850f42fba0c81b2cc4b95b42373585078"
    sha256 cellar: :any,                 arm64_sonoma:  "b7a9a7372609b81930b20be11a6ba60eaeb54fdc5c341d4e579183fb95a05db2"
    sha256 cellar: :any,                 sonoma:        "f600df26b5ec2b2faa832b8f51df49e1f35a6f413c27455227673a7174e07f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca12a71a357123c77e9a02335cc5397022bb8cd8740032803ad8df3aeff39ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1adba747d9849aec8a4b4f9277fac2429d7342ab6782f6385ee0bd641e4428fc"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: ["cassandra-driver", "setuptools"]

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/b2/6f/d25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818/cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output(bin/"ccm", 1)
  end
end
