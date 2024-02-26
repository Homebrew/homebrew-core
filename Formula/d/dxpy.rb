class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/e1/ac/5d27b7f1ce923b9a96d254092b2ba3de8c14933133556b8d4f0c26951660/dxpy-0.369.1.tar.gz"
  sha256 "6e83d6c0756ff2b6691c9b789298ef5fdbe3f3df67b8fd90beb8420782219d41"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2618381b8fd642b5102ff484c0e16267f39aa14c99c4f2fc2ceb88964227794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e631144ece5ff0e116e8a6de094e9c24a405625779218f45036d8c5b7cc9dbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796e5490e206df08c2a854e29acda8bfc37f4794a6837cbddd12ae1fc71303f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8c4e58152f24fa6d5a23f61702047d238bf65750a76db3929ba9b69fd8de8e4"
    sha256 cellar: :any_skip_relocation, ventura:        "bf94d1497c066739b422ab430d86bdacefde198541dafb1b0c507f65d525e482"
    sha256 cellar: :any_skip_relocation, monterey:       "c33fc748615f018504a94944800057752d18d93affd4e72377423b10663120ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9d13c8a1acf06115d63158aa96daec2fa97dd32690ff7a5ba73ef1eb410f6e"
  end

  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
