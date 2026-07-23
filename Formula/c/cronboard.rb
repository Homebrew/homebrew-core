class Cronboard < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based dashboard for managing cron jobs locally and on servers"
  homepage "https://cronboard.dev/"
  url "https://github.com/antoniorodr/cronboard/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "304de09999002159e9adb142c34b95959e682261beb39b4f0f0453054f7581f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fbee7f42352c3ba3567bef5de66523b87c373982a0363156533482b7e5440c58"
    sha256 cellar: :any, arm64_sequoia: "90f711e4dfdfdadc6ca409068351c127960b205f7edc190118e005978b6439d8"
    sha256 cellar: :any, arm64_sonoma:  "ab737aa0d09aca8349759fae512a349b114bf10729e10d09df5dae7761e1c518"
    sha256 cellar: :any, sonoma:        "8946687ca63582d9bdb56ca42a1e9331b56ac9f7d5110548ce7d4465784b61bd"
    sha256 cellar: :any, arm64_linux:   "44a63fd7c69a00a6ec788618d96655ca2e0ed0f4b998b391aa50f3b21cea9cf1"
    sha256 cellar: :any, x86_64_linux:  "add8f3dd877c48ca51148d53238530514c30f0fbe4a3b8c0bf94c27ed7bea3da"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "cron-descriptor" do
    url "https://files.pythonhosted.org/packages/91/75/b44b05ae7d1e49b59a27a917c44e04ce9aa4cebdd05dac42ba7df06a91b4/cron_descriptor-2.1.0.tar.gz"
    sha256 "ecddb8b2f6c5286398949aaefe185364666af74f33b01877c61378e1fd4e38e6"
  end

  resource "croniter" do
    url "https://files.pythonhosted.org/packages/37/57/2e2a65aee2a70483cb28e2b7e15a072d00a523207593b44400d4717bb100/croniter-6.2.4.tar.gz"
    sha256 "fc124f751b1b04805c2a04b061898b436b45ab2320b045e1e052ea895de65189"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/62/93/dcc25d52f49022ae6175d15e6bd751f1acc99b98bc61fc55e5155a7be2e7/paramiko-5.0.0.tar.gz"
    sha256 "36763b5b95c2a0dcfdf1abc48e48156ee425b21efe2f0e787c2dd5a95c0e5e79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/52/cd/4f25b2f95b23f5d2c9c1fe43e49841bff5800562149b2666afc09309aa8f/platformdirs-4.10.1.tar.gz"
    sha256 "ceab4084426fe6319ce18e86deada8ab1b7487c7aee7040c55e277c9ae793695"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "python-crontab" do
    url "https://files.pythonhosted.org/packages/99/7f/c54fb7e70b59844526aa4ae321e927a167678660ab51dda979955eafb89a/python_crontab-3.3.0.tar.gz"
    sha256 "007c8aee68dddf3e04ec4dce0fac124b93bd68be7470fc95d2a9617a15de291b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/1e/3a/80411bc7b94969eb116ad1b18db90f8dce8a1de441278c4a81fee55a27ca/textual_autocomplete-4.0.6.tar.gz"
    sha256 "2ba2f0d767be4480ecacb3e4b130cf07340e033c3500fc424fed9125d27a4586"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = if OS.mac?
      "Operation not permitted: '/usr/bin/crontab'"
    else
      "Error: Can't read crontab"
    end
    assert_match output, shell_output("#{bin}/cronboard 2>&1")
  end
end
