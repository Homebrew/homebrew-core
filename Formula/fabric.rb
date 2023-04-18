class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/2f/84/dbcbc78055397a783134f56b30c70a61a645fae568d73ec7aa301f5f93fd/fabric-3.0.0.tar.gz"
  sha256 "bfe960c1ae904e7624af9d40ad5b9b99581ed9c4fd09349c0d02b7486e1d0f89"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3e7a998cbf4c4b494913fd5b490993da538664297fd1914cc8515b690c884b18"
    sha256 cellar: :any,                 arm64_monterey: "03e191da03a9635719ddf90cb9609694efd61bca6951f5546d598887464b2691"
    sha256 cellar: :any,                 arm64_big_sur:  "f1c8329161860111aeee27be89c54b4b33ca9240a3d7bb16231ce278998e48b1"
    sha256 cellar: :any,                 ventura:        "9020bd6bee66200685748c2bb2d7e88c6e67e3f1c14f76d0c9d541b50742ffa5"
    sha256 cellar: :any,                 monterey:       "b0b5a088a0fe8edca05cd28bd58ce37ff61a7ba229d130e783fd053623f87ca6"
    sha256 cellar: :any,                 big_sur:        "7be3304df4e392f04a6adc9990fb4e15467b71ce0129d4eb6d5ec1ef879836a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15b8c75bb33f2b76915cda69bead546dd2a6c354078820712dad79736a826c2"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "pyinvoke"
  depends_on "python@3.11"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/3b/6b/554c00e5e68cd573bda345322a4e895e22686e94c7fa51848cd0e0442a71/paramiko-3.0.0.tar.gz"
    sha256 "fedc9b1dd43bc1d45f67f1ceca10bc336605427a46dcdf8dec6bfea3edf57965"
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

    # we depend on pyinvoke, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    pyinvoke = Formula["pyinvoke"].opt_libexec
    (libexec/site_packages/"homebrew-pyinvoke.pth").write pyinvoke/site_packages
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
