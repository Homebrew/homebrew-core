class Cronboard < Formula
  include Language::Python::Virtualenv

  desc "Terminal-based dashboard for managing cron jobs locally and on servers"
  homepage "https://github.com/antoniorodr/cronboard"
  url "https://github.com/antoniorodr/cronboard/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "6b3ca130c5772c2d6d664fd376e3ba40d944fe6dce92414f192448684df35e37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af16312bd447636f9031cd3bbe94f02e499d099994ae16d7e908a05c9bfc1829"
    sha256 cellar: :any,                 arm64_sequoia: "1cb63baf33812d4fb040777a03f8b4f20aab2e315110f57deb862b36194a2e9b"
    sha256 cellar: :any,                 arm64_sonoma:  "11f283e24d045fda175068ae1d13b48fbbcb72d73d8af72f6ead4d6c0d4d9802"
    sha256 cellar: :any,                 sonoma:        "5242ec350d986c9568cffc2ef6d1c98c2bd8cbbcf53d40d72213137f4b9cb856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6b7cb51b83e5c802cd9e0cbf358df19939f0caef70040e76f79c109c7dd926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "429d1467a4eb69b26096d69cc60e6c2eeff26bf6b4a8fb516fffca4d3d0661d1"
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
    url "https://files.pythonhosted.org/packages/f2/ce/cd3cc454ea73e8a38be79723b925611d2556037f938372ad594373f187b4/cron_descriptor-2.0.8.tar.gz"
    sha256 "7e487efe14a99a3c1c23bb5302bb75c8bf5d54bca82931bf71f5ae2855939772"
  end

  resource "croniter" do
    url "https://files.pythonhosted.org/packages/df/de/5832661ed55107b8a09af3f0a2e71e0957226a59eb1dcf0a445cce6daf20/croniter-6.2.2.tar.gz"
    sha256 "ba60832a5ec8e12e51b8691c3309a113d1cf6526bdf1a48150ce8ec7a532d0ab"
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
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
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
    url "https://files.pythonhosted.org/packages/19/89/bec5709fb759f9c784bbcb30b2e3497df3f901691d13c2b864dbf6694a17/textual-8.2.4.tar.gz"
    sha256 "d4e2b2ddd7157191d00b228592b7c739ea080b7d792fd410f23ca75f05ea76c4"
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
