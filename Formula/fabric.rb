class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/d8/b0/fc6880fd6e24b60ccb5e3e1b673cec847d56b8176311f77c63f542fe9fd4/fabric-3.1.0.tar.gz"
  sha256 "ea1c5ea3956d196b5990ba720cc8ee457fa1b9c6f265ab3b643ff63b05e8970a"
  license "BSD-2-Clause"
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ac2915235a565fac06db88bcdf7d33d926b825ed641babe056d5f837520e884e"
    sha256 cellar: :any,                 arm64_monterey: "05124202110f6a1c893d20bb425df00b68d56fdd2d38fb26f35102c0791b237c"
    sha256 cellar: :any,                 arm64_big_sur:  "0ef853648086fb8bd5a22b37e3568d119d082a6322df520d4b1879ae7c86a0e2"
    sha256 cellar: :any,                 ventura:        "567e8888e01a9ab3554fd8bbe4b6cc4519f3550474ce4759ea03c0d98d9f5fde"
    sha256 cellar: :any,                 monterey:       "21cc0f5c40c8c8925b9890bd7d0e7b50a216cab73b280d0405a470b25daa2622"
    sha256 cellar: :any,                 big_sur:        "ab424d19f7d879374110a15453f2f9ce8903946b2bc77ca4f70f92290f07955b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a42e54abc6ca47e1b5321f78160f1987ed43b49dfe95f868ac0ec6d161b3c9c"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
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
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/87/62/cee9551811c846e9735f749dbdf05d4f9f0dbcecd66eae35b5daacf9a117/paramiko-3.2.0.tar.gz"
    sha256 "93cdce625a8a1dc12204439d45033f3261bdb2c201648cfcdc06f9fd0f94ec29"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
