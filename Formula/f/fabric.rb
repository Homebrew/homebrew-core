class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/34/6a/8e8734a47dad3cf6cbf4ba8631340814cd374ea58452133a62714dc6338b/fabric-3.2.1.tar.gz"
  sha256 "81293d7e2b509d37e51bb49a0151191455f5a7ea11ebaa158bdee995b844c668"
  license "BSD-2-Clause"
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a44e63aebb1059c09035289bf10f9edd127816c14f28778c20334046249ffad"
    sha256 cellar: :any,                 arm64_monterey: "4d984a18c6bd0fc5050f92016435c32ef95630cc663e44f8e99524ff0b9e042b"
    sha256 cellar: :any,                 arm64_big_sur:  "cf95c2e016afaa6178c22431463e95bfd90286de3fdb886b880f728b3387474e"
    sha256 cellar: :any,                 ventura:        "ed088d699657b0700077a847af3c1a026204ff6b32b36dbce4586905604c80f4"
    sha256 cellar: :any,                 monterey:       "88c5649231e8bacc40ee02833f03b161384bb4518aa9d49f9c449a3dfb6f25aa"
    sha256 cellar: :any,                 big_sur:        "5a9773a10bd322e0364d27a0c359c839f33977a083e94fdad3021ca0d987cd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48eebd617e0242ce94e829b4cca34875849a75aac7abc258038c72112e443ba9"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "pyinvoke"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
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
