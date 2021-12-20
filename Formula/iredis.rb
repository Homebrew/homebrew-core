class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.io"
  url "https://files.pythonhosted.org/packages/73/b9/9f282c23eaa45a6c468b27a9d9263f7cb86699785d47e2d8b165daf8b928/iredis-1.10.0.tar.gz"
  sha256 "4f21862dbf3efc92593852bd3dc7231c437b8d99494c10352bdc91d64d64adb4"
  license "BSD-3-Clause"
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c16776a00ab75e483cb165926fb7abc46fc776f7ec4ebef27c4145f656fd02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5244f3000f4ae1070ef1ff2c4a573010c855dc2bebf49dbcb51c748f12f5e930"
    sha256 cellar: :any_skip_relocation, monterey:       "d84ce0b1db3670cb8feda63357891a6ec7dc30ea72dddc994a8c92ea1222bd99"
    sha256 cellar: :any_skip_relocation, big_sur:        "87232e4432a038363d2f82d46432413b552e36f1d102262b44e9313f4c047477"
    sha256 cellar: :any_skip_relocation, catalina:       "69fdb1735e81cd4c42331482397549920c14c5551459366db23abc87eb31f664"
    sha256 cellar: :any_skip_relocation, mojave:         "e16b775087fa092b6e03091b4bda5f52e47aaea4323dc1741650d141489f9863"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/b5/d8/51ace1c1ea6609c01c7f46ca2978e11821aa0efaaa7516002ef6df000731/importlib_resources-5.4.0.tar.gz"
    sha256 "d756e2f85dd4de2ba89be0b21dba2a3bbec2e871a42a3a16719258a11f87506b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"
    sha256 "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/15/e4/f138d6319c02a6052a590ef32e94366b74581973b43665c2960b07b9ec24/prompt_toolkit-3.0.24.tar.gz"
    sha256 "1bb05628c7d87b645974a1bad3f17612be0c29fa39af9f7688030163f680bad6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytzdata" do
    url "https://files.pythonhosted.org/packages/67/62/4c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53/pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/b3/17/1e567ff78c83854e16b98694411fe6e08c3426af866ad11397cddceb80d3/redis-3.5.3.tar.gz"
    sha256 "0e7e0cfca8660dea8b7d5cd8c4f6c5e29e11f31158c0b0ae91a397f00e5a05a2"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end
