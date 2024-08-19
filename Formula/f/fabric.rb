class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
  sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "e678a66727889cba1b4d41687dfc8cec63965c816b216bfcbc8f476c5ab27151"
    sha256 cellar: :any,                 arm64_ventura:  "aa44439db06456739c8fad795ee9b86c57b62ee0b7fc9df4989dc0922895e0da"
    sha256 cellar: :any,                 arm64_monterey: "d1ce1450a673c8cbf58d19622314dfa6fccf0e7752fa55c0d703b79bc9f87c39"
    sha256 cellar: :any,                 sonoma:         "4bd9b0e6fd6bcc39a42dfd29150c6060969ea607cb08fdf78ac003dae7c64fd6"
    sha256 cellar: :any,                 ventura:        "0f1571f4ef4d1f41ce846e977a7190185e15a471797b6df47879be0b4ac8f516"
    sha256 cellar: :any,                 monterey:       "6bf1bb73957e4be1b1adba925d2c15aaeee3a5d0bdc56b3ac87011f8540bc648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87c1d40bfb7b8be3ce0762a6ae5f7d4b4580b3a285f315c0ccde367cf7b5028"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e4/7e/d95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0/bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/0b/6a/1d85cc9f5eaf49a769c7128039074bbb8127aba70756f05dfcf4326e72a1/paramiko-3.4.1.tar.gz"
    sha256 "8b15302870af7f6652f2e038975c1d2973f06046cb5d7d65355668b3ecbece0c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
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
