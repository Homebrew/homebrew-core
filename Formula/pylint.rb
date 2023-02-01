class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/16/4d/c063db1afaa944b0f790348c68a3669d8e8f52ddfff2006a1a85d814e083/pylint-2.16.0.tar.gz"
  sha256 "43ee36c9b690507ef9429ce1802bdc4dcde49454c3d665e39c23791567019c0a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e6f61b221dad13a1d8626337f0fe0ba9b9b68b65e05c792390caece1cc81da7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a0964ce79dc81dea582aa54812fc36e982416f9beb62f8f08391e68107592ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62395eba374ccd9bd53f2626ff77ae525e2d48a96ddc0dd15c574286b375d72a"
    sha256 cellar: :any_skip_relocation, ventura:        "edfb93568ff4ab44f3f0fcb4340f2157218f01f249632d1bc699259d94891e6b"
    sha256 cellar: :any_skip_relocation, monterey:       "1635bb1741b882582b57767f0c45f2c3515fdff355583ad3af302241c988c51e"
    sha256 cellar: :any_skip_relocation, big_sur:        "14a47f5982b778348ca57bffd067943e4d32a66a9e5205fc32dd102c4308c353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c661479d7f2b22e02f5609464e7875d720a840a52e513cfb71b01ae2cd80f292"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/6d/1e/b6f6065acb262dd1f7466d23626ea1c7bf033c0675294c41cf96deb86d3a/astroid-2.14.1.tar.gz"
    sha256 "bd1aa4f9915c98e8aaebcd4e71930154d4e8c9aaf05d35ac0a63d1956091ae3f"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
