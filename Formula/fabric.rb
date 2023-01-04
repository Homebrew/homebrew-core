class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/1f/36/9969093324a67cee916f484eda7b3547e8f8e6077f5f2a1814cde80d6fc2/fabric-2.7.1.tar.gz"
  sha256 "76f8fef59cf2061dbd849bbce4fe49bdd820884385004b0ca59136ac3db129e4"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "135dc5cc6e423e5f934a7d05171305f3f424605eb9a503a6f2f4071c37913dc3"
    sha256 cellar: :any,                 arm64_monterey: "ccd2663005a3c16d686d0aa758a3289e158e8d003b47ee08ef277a6448836b89"
    sha256 cellar: :any,                 arm64_big_sur:  "630be8c0a1469b55894d3ed7bf2dcdba281dabbe45d3bb8a28e968dff71dcab1"
    sha256 cellar: :any,                 ventura:        "29b2c1aa7da4b29debc87bbe804f6dd663bf457f4801db31eed436ac8739c017"
    sha256 cellar: :any,                 monterey:       "972cf4da10edce2148cb1bd3a8e9bcb2228ab3a4bdb4af61ae5ec8671c5b10b3"
    sha256 cellar: :any,                 big_sur:        "aed7203872c89087d2464ed1cf86f839b96ff838846e2f117c38c02f831ac87f"
    sha256 cellar: :any,                 catalina:       "2acb1f21d3a07f4f22fc564630ce0d8c5e254982332d7d4cf2fc72d4a9fc0b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90be4f0931d76416c08baa7d8730849ea3673ee92085559cf13de4d8e47e7626"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "pyinvoke"
  depends_on "python@3.11"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/e3/c46c274cf466b24e5d44df5d5cd31a31ff23e57f074a2bb30931a8c9b01a/cryptography-39.0.0.tar.gz"
    sha256 "f964c7dcf7802d133e8dbd1565914fa0194f9d683d82411989889ecd701e8adf"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/98/75/e78ddbe671a4a59514b59bc6a321263118e4ac3fe88175dd784d1a47a00f/paramiko-2.12.0.tar.gz"
    sha256 "376885c05c5d6aa6e1f4608aac2a6b5b0548b1add40274477324605903d9cd49"
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
