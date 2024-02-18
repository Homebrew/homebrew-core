class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/e1/ac/5d27b7f1ce923b9a96d254092b2ba3de8c14933133556b8d4f0c26951660/dxpy-0.369.1.tar.gz"
  sha256 "6e83d6c0756ff2b6691c9b789298ef5fdbe3f3df67b8fd90beb8420782219d41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd8b602d1c1d43d2377b54ab2680cfb2587f2290219115f99e1fe8dc33c51e22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6e90dd5b7ec5de109092ddac9b96d78bea1625067f6ae7f3c72cc50cba135f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26cb83f75137fae05145b70e91e6acd01190af9e9f3929804c6ac2babd9e6eed"
    sha256 cellar: :any_skip_relocation, sonoma:         "a89542297dc1fc1f35f332bf624468f008221f481293d721db3c6df03bd6ed36"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd2f5b9911126fa4c9fe5c73ffc9a90635587ffcf782b73d78c956587af8074"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f0cd0c0d558b4f96cf6d3fb35b647d6584b9ab95da4fa4bd94268b22e66a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d9d3bd693e4eb4a04eb80600b8c3311037d42ecad85d31127dd15189be7c66"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python-websocket-client"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  def python3
    "python3.12"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
