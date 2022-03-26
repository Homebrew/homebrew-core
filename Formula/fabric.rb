class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/fc/c8/6a002a659d78db66ed134fd390773afd87a638026feef2c8efe6a4492776/fabric-2.7.0.tar.gz"
  sha256 "0bf797a68c4b389720dc4dd6181497a58c41ed762e283d9e3c1b0148b32a9aff"
  license "BSD-2-Clause"
  head "https://github.com/fabric/fabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "80e09e5d248cc2748198ad335bfa8a32f5e49716b0d4a86612d403de145accab"
    sha256 cellar: :any,                 arm64_big_sur:  "508bc4f66f14e7d63e54076545e90f3dbada8301d298f455a72ffd1d92194b19"
    sha256 cellar: :any,                 monterey:       "1d6cd5e600c309722e12bb6526c7a2dfbd2848be2ab11ade3d82c1c661caad9a"
    sha256 cellar: :any,                 big_sur:        "814bc0ac213cd0c2e75e2d527b83d908cda4c216fafa84c6841ba7d15e592e31"
    sha256 cellar: :any,                 catalina:       "2cb00d4b1f5a8b23fc880223888d988ce8e338d7493e34965aab1469d8ce224a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a679e8425b4e67980aed69dd9a3a7ecd9e30e95e4b7b0099b3c3fdc45d5acfee"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/55/a2/763dc56e746ca013061b26c95868cb7f832c2a87dc27ed749641a734957f/invoke-1.7.0.tar.gz"
    sha256 "e332e49de40463f2016315f51df42313855772be86435686156bc18f45b5cc6c"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/d4/93/1a1eb7f214e6774099d56153db9e612f93cb8ffcdfd2eca243fcd5bb3a78/paramiko-2.10.3.tar.gz"
    sha256 "ddb1977853aef82804b35d72a0e597b244fa326c404c350bd00c5b01dbfee71a"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/31/51/99caf463dc7c18eb18dad1fffe465a3cf3ee50ac3d1dccbd1781336fe9c7/pathlib2-2.3.7.post1.tar.gz"
    sha256 "9fe0edad898b83c0c3e199c842b27ed216645d2e177757b2dd67384d4113c641"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~EOS
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    EOS
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
