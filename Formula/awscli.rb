class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.11.0.tar.gz"
  sha256 "30dc7235fba29d18c19460dcb3d54ca7d105dd5fb9ef84408cfad673a7817961"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff4d98b287825f1d43e75a693e8d6287a904ff37ddd20233dd35d037de9bfc29"
    sha256 cellar: :any,                 arm64_monterey: "136486ed80af0224173168115675eff3e352d071d75e01c66a0ff8df4816b1dd"
    sha256 cellar: :any,                 arm64_big_sur:  "b7f33b169a4c249b5abcaebb1b254e77cf2b1df6b1be795e65a839bfc2f64ad5"
    sha256 cellar: :any,                 ventura:        "8576e0661ff2083217131b004ea40374a35b6d2e62637af2c8222b455639a73b"
    sha256 cellar: :any,                 monterey:       "28f5ee3a11700d96d44b7540fd4f4ddb05868c8de53598bd75e9e2b0d80ab021"
    sha256 cellar: :any,                 big_sur:        "2b2222132bef790d2b7f4036211b9254b4fc49c0079ff8a966e62fa4d7786ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4373788a2ae6df127b153d2c54e16d66cb5ec99ec6e65f117bc90bf3b01b2028"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "mandoc"

  # Python resources should be updated based on setup.cfg. One possible way is:
  # 1. Run `pipgrip 'awscli @ #{url}' --sort`
  # 2. Ignore `docutils` and `six`. Update all other PyPI packages

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/ae/98/dda092078f2d47bad08e184ab9d364b8f89166497062bc1cf811c0bbbde2/awscrt-0.16.10.tar.gz"
    sha256 "3101499b479b82f0403f615bf520c1f8b9506818d275e3e28ade25cc6bcdb92b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/e3/3f/41186b1f2fd86a542d399175f6b8e43f82cd4dfa51235a0b030a042b811a/cryptography-38.0.4.tar.gz"
    sha256 "175c1a818b87c9ac80bb7377f5520b7f31b3ef2a0004e2420319beadedb67290"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/37/34/c34c376882305c5051ed7f086daf07e68563d284015839bfb74d6e61d402/prompt_toolkit-3.0.28.tar.gz"
    sha256 "9f1cd16b1e86c2968f2519d7fb31dd9d669916f515612c269d14e9ed52b51650"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def python3
    which("python3.11")
  end

  def install
    # Temporary workaround for Xcode 14's ld causing build failure (without logging a reason):
    # ld: fatal warning(s) induced error (-fatal_warnings)
    # Ref: https://github.com/python/cpython/issues/97524
    ENV.append "LDFLAGS", "-Wl,-no_fixup_chains" if DevelopmentTools.clang_build_version >= 1400

    # The `awscrt` package uses its own libcrypto.a on Linux. When building _awscrt.*.so,
    # Homebrew's default environment causes issues, which may be due to `openssl` flags.
    # This causes installation to fail while running `scripts/gen-ac-index` with error:
    # ImportError: _awscrt.cpython-39-x86_64-linux-gnu.so: undefined symbol: EVP_CIPHER_CTX_init
    # As workaround, add relative path to local libcrypto.a before openssl's so it gets picked.
    if OS.linux?
      python_version = Language::Python.major_minor_version(python3)
      ENV.prepend "CFLAGS", "-I./build/temp.linux-x86_64-#{python_version}/deps/install/include"
      ENV.prepend "LDFLAGS", "-L./build/temp.linux-x86_64-#{python_version}/deps/install/lib"
    end

    # setuptools>=60 prefers its own bundled distutils, which is incompatible with docutils~=0.15
    # Force the previous behavior of using distutils from the stdlib
    # Remove when fixed upstream: https://github.com/aws/aws-cli/pull/6011
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      virtualenv_install_with_resources
    end
    pkgshare.install "awscli/examples"

    rm Dir[bin/"{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
    site_packages = libexec/Language::Python.site_packages(python3)
    assert_includes Dir[site_packages/"awscli/data/*"], "#{site_packages}/awscli/data/ac.index"
  end
end
