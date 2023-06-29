class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/d8/b0/fc6880fd6e24b60ccb5e3e1b673cec847d56b8176311f77c63f542fe9fd4/fabric-3.1.0.tar.gz"
  sha256 "ea1c5ea3956d196b5990ba720cc8ee457fa1b9c6f265ab3b643ff63b05e8970a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "92ba78f982b2d6832fe8705b1a50a6c4ca99149571f78f7fa6a9140b76d960a5"
    sha256 cellar: :any,                 arm64_monterey: "5a7646ca3e67bd2e0873642c05299869d125c792b2149ece40f0857c5d094452"
    sha256 cellar: :any,                 arm64_big_sur:  "4eca4dc3aaa7315f46470e5506d64900de16feb646c697080adbf24260fff923"
    sha256 cellar: :any,                 ventura:        "bd0cc67a526f5620f51c262fdcc88b727177a6255ec497390d53e7a38a139602"
    sha256 cellar: :any,                 monterey:       "c74a6bc0847df2a18980a65c0694bbd302c930cb93c812fd9a197a4527b38ac4"
    sha256 cellar: :any,                 big_sur:        "8d09802be13e8f6e079f981474e78cb2bfba910ff7205b1c83dbbbb13f307653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df4c4e13fe3836227ec61f4ff36cdfe7514f6ba4eeba5c227c5907fce0775cfa"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pyinvoke"
  depends_on "python@3.11"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
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

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
