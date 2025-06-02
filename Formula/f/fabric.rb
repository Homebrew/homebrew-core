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
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "4d1555e8e1817baca2b6923fdb04c78ad0e4e31c8a73335cbb25572c8d90ab5e"
    sha256 cellar: :any,                 arm64_sonoma:  "af5461c5eec7061d03b600d697c31c9819f0601bc2340636b852beb2b48e67c1"
    sha256 cellar: :any,                 arm64_ventura: "462f81ce1dad72d97411bc6dd9413b009dd661f9ea562a2f388343363f072ed8"
    sha256 cellar: :any,                 sonoma:        "887b91b1a6d0a1ab97b9a4d114575f9da05e0bc54568ce249f0b8f02d897f6b7"
    sha256 cellar: :any,                 ventura:       "421882203efbb325031a85f98942f5f0a46ac043595c855b77037e7a6fbcc4ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa678291a94d4bcaca4e18a4f0e0067dabc7a7fa64c1fc89ee37504ad7d55e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250317267233bf7f607ad268ddd2089c29f8722840ba8a3f37a1a33603f84911"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/1b/0f/c00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609b/paramiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
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
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"fabfile.py").write <<~PYTHON
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    PYTHON
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
