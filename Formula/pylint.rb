class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/96/d2/192ac213f4a61118eacc79efbc7441460b5d5be39e821e2ee282ef6c68a5/pylint-2.16.2.tar.gz"
  sha256 "13b2c805a404a9bf57d002cd5f054ca4d40b0b87542bdaba5e05321ae8262c84"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9138cae2ea7c1c6221b7d9eca9bb8643230c900bf5774811185773c1adccdab7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc11ebc2f9e6b9d44078d3742aa03a17f3bb6f47819cc9cd513a17df782bf2a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "913f230e47b8c2004fdf7f24b74dec42cd2c21f57510ff56d4b5f26a0ef3ae16"
    sha256 cellar: :any_skip_relocation, ventura:        "64fd2f4c68256b5e562b042d56bac97cd3d95d092ad69e438bab7862ec61e826"
    sha256 cellar: :any_skip_relocation, monterey:       "bc1c892920e6fd18cdc806844fbbe7a75eead32ffc66d613a41139d7c4d41ec2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d45e43f454387892c19f22acd7f61c5717132e0f6b8af92059a442a58f3f1d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2b3142c79d1e9909f79addb413ab111ab4d6edd6bc04279d016f967dfdb19d"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/15/e5/7dea50225cd8b44f1488ae83a243467fe6d2a3c4f611d865085b4bba67e5/astroid-2.14.2.tar.gz"
    sha256 "a3cf9f02c53dd259144a7e8f3ccd75d67c9a8c716ef183e0c1f291bc5d7bb3cf"
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
    url "https://files.pythonhosted.org/packages/11/39/702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762/platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
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
