class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://files.pythonhosted.org/packages/0c/b0/4026175cc310b35e15e1447ab8ca13742e98960f14bde087b069dc760e44/internetarchive-1.9.3.tar.gz"
  sha256 "bad1c4152fb6286ce7c77737a853bb4e45bcefb89ca5834d75607419f08cb6fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "94aee05412f4f7389b422504863b85a433bf9f947a5de37625e8a73b3e69e1b2" => :catalina
    sha256 "7421d0fa3d6618108771dc6bb7cafe920f34f6855dee980ca87f7c16fc421847" => :mojave
    sha256 "5586ef6c1de81e7cabeaa9aa620ea9695b58668415231314bbcacf997177d3f7" => :high_sierra
  end

  depends_on "python@3.8"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "backports.csv" do
    url "https://files.pythonhosted.org/packages/79/0c/d0eaa9380189a292121acab65199ac95b9209b45006ad8aa5266abd36943/backports.csv-1.0.7.tar.gz"
    sha256 "1277dfff73130b2e106bf3dd347adb3c5f6c4340882289d88f31240da92cbd6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  # requires 0.5.5
  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz"
    sha256 "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/70/9f/6f0bfbb4cc1401ce994d336bcb4ed2aa924f395e7fd1926511c04a52eee1/jsonpatch-1.25.tar.gz"
    sha256 "ddc0f7628b8bfdd62e3cbfbc24ca6671b0b6265b50d186c2cf3659dc0f78fd6a"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/f7/95/db0f50583e47d8b8cf346599880734de980a9f4bf040a0b5fb236e891c71/schema-0.7.1.tar.gz"
    sha256 "c9dc8f4624e287c7d1435f8fd758f6a0aabbb7eff442db9192cd46f0e2b6d959"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/12/67/e736c012c6c8b4092dd54bb9bdd7737acf9a140a98c58b87c35363d0105d/tqdm-4.45.0.tar.gz"
    sha256 "00339634a22c10a7a22476ee946bbde2dbe48d042ded784e4d88e0236eca5d81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/ia"
  end

  test do
    metadata = JSON.parse shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end
