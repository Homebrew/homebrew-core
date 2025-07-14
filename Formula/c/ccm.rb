class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/apache/cassandra-ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/cassandra-ccm.git", branch: "trunk"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb6c2ab38ac79ff2b3718e344517f07ebb2c9391227676a507d721337981b5cc"
    sha256 cellar: :any,                 arm64_sonoma:  "ef958862ebdc0d3203850a3055913742f0a784e339cbdede518f5582f9806185"
    sha256 cellar: :any,                 arm64_ventura: "622faec5bb8d2c454beafd31cd567a9243cb45cf096213a50701dde2ba150c43"
    sha256 cellar: :any,                 sonoma:        "ad8ca422f7aef4dbed4984eebea2f52aeac21d72a53a3491bc23911962efd642"
    sha256 cellar: :any,                 ventura:       "fd3bd745bc0600e892c0372529149976a27d35ac624862764c8a5d9680107a67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f31636caef911a604264f28bc73ab30f721778dfcc296300ddf3f191a5b252e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe165a475bb32e289f0042ddc39bb6253670c10a988430c00f313c0027ebfeab"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/b2/6f/d25121afaa2ea0741d05d2e9921a7ca9b4ce71634b16a8aaee21bd7af818/cassandra-driver-3.29.2.tar.gz"
    sha256 "c4310a7d0457f51a63fb019d8ef501588c491141362b53097fbc62fa06559b7c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "geomet" do
    url "https://files.pythonhosted.org/packages/cf/21/58251b3de99e0b5ba649ff511f7f9e8399c3059dd52a643774106e929afa/geomet-0.2.1.post1.tar.gz"
    sha256 "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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
