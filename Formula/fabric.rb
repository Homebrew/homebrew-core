class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/1f/36/9969093324a67cee916f484eda7b3547e8f8e6077f5f2a1814cde80d6fc2/fabric-2.7.1.tar.gz"
  sha256 "76f8fef59cf2061dbd849bbce4fe49bdd820884385004b0ca59136ac3db129e4"
  license "BSD-2-Clause"
  head "https://github.com/fabric/fabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5231d4e38a65bd651aa694917f4fe7e9f44c8b2354c32eb067071d3f67e53016"
    sha256 cellar: :any,                 arm64_big_sur:  "fc73e80710ba066771de6148f04b39faf8a0e712693036bb831a8b99d6a7f864"
    sha256 cellar: :any,                 monterey:       "5aa89cca5588a12c061165db094667586b9f68b7bfdf878c0d6fe61aa6b16365"
    sha256 cellar: :any,                 big_sur:        "b440b03f146c93e3f532b715eec151fe213465eb6b9a7adbe1f61f531c1b7b8e"
    sha256 cellar: :any,                 catalina:       "706ea2ad3533ea1ec4eb61e6a3cfb86c0f908afbb47404adbf86e983077be9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83701718ddd05c257ef3dbec2a33cd99ea6494c1f4f57350bdd1aac421b4859c"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e8/36/edc85ab295ceff724506252b774155eff8a238f13730c8b13badd33ef866/bcrypt-3.2.2.tar.gz"
    sha256 "433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/89/d9/5fcd312d5cce0b4d7ee8b551a0ea99e4ea9db0fdbf6dd455a19042e3370b/cryptography-37.0.4.tar.gz"
    sha256 "63f9c17c0e2474ccbebc9302ce2f07b55b3b3fcb211ded18a42d5764f5c10a82"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/df/59/41b614b9d415929b4d72e3ee658bd088640e9a800e55663529a8237deae3/invoke-1.7.1.tar.gz"
    sha256 "7b6deaf585eee0a848205d0b8c0014b9bf6f287a8eb798818a642dff1df14b19"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1d/08/3b8d8f1b4ec212c17429c2f3ff55b7f2237a1ad0c954972e39c8f0ac394c/paramiko-2.11.0.tar.gz"
    sha256 "003e6bee7c034c21fbb051bf83dc0a9ee4106204dd3c53054c71452cc4ec3938"
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
