class Cronboard < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based dashboard for managing cron jobs locally and on servers"
  homepage "https://github.com/antoniorodr/cronboard"
  url "https://github.com/antoniorodr/cronboard/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "593a33f8cb01f369ea4fa53f29628fc77783f7484b61072ff20948fdb0017a94"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e5e6bfffd6f71684b2c14d1266473592e43b0a838a8adde8d38de6b56f2a48f"
    sha256 cellar: :any,                 arm64_sequoia: "ef905ce3834c314650767e003a1ed4ab0fbea09f537a0d0d0ab13b6a106b6960"
    sha256 cellar: :any,                 arm64_sonoma:  "c41543a007f615fbb45fedf105869515112a897d38929126323a2d03ab130834"
    sha256 cellar: :any,                 sonoma:        "c19728db04b2951ba06943ee70a58a1cc46e5936746a30071331d2ef755afcab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989a75d6e17412df103c5a66dec43def4e3c891a0fb46baa9029b1ff9595954b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975bc685c909e4da37016d68e5e50145592cc9f8c9c7f6861c099ae58adadd5d"
  end

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
    url "https://files.pythonhosted.org/packages/7c/31/0b21d1599656b2ffa6043e51ca01041cd1c0f6dacf5a3e2b620ed120e7d8/cron_descriptor-2.0.6.tar.gz"
    sha256 "e39d2848e1d8913cfb6e3452e701b5eec662ee18bea8cc5aa53ee1a7bb217157"
  end

  resource "croniter" do
    url "https://files.pythonhosted.org/packages/ad/2f/44d1ae153a0e27be56be43465e5cb39b9650c781e001e7864389deb25090/croniter-6.0.0.tar.gz"
    sha256 "37c504b313956114a983ece2c2b07790b1f1094fe9d81cc94739214748255577"
  end

  resource "dt-croniter" do
    url "https://files.pythonhosted.org/packages/de/8e/173c5cc010ab08e8e8b1528772b790f431757ce3e4c7fdae7b4c5fc35edd/dt-croniter-6.0.1.tar.gz"
    sha256 "098a544670fa08afee3cc98499b9c5f0747846265a27cdce87ad5958806d4aa2"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/56/db/b8721d71d945e6a8ac63c0fc900b2067181dbb50805958d4d4661cf7d277/pytz-2026.1.post1.tar.gz"
    sha256 "3378dde6a0c3d26719182142c56e60c7f9af7e968076f31aae569d72a0358ee1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/be/08/c6bcb1e3c4c9528ec9049f4ac685afdafc72866664270f0deb416ccbba2a/textual-8.0.2.tar.gz"
    sha256 "7b342f3ee9a5f2f1bd42d7b598cae00ff1275da68536769510db4b7fe8cabf5d"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/1e/3a/80411bc7b94969eb116ad1b18db90f8dce8a1de441278c4a81fee55a27ca/textual_autocomplete-4.0.6.tar.gz"
    sha256 "2ba2f0d767be4480ecacb3e4b130cf07340e033c3500fc424fed9125d27a4586"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c3/af/14b24e41977adb296d6bd1fb59402cf7d60ce364f90c890bd2ec65c43b5a/tomlkit-0.14.0.tar.gz"
    sha256 "cf00efca415dbd57575befb1f6634c4f42d2d87dbba376128adb42c121b87064"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
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
