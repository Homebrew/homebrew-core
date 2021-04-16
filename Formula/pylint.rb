class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/2d/5b/491cf9e85288c29759a6535e6009938c2141b137b27a0653e435dcbad6a2/pylint-2.7.4.tar.gz"
  sha256 "bd38914c7731cdc518634a8d3c5585951302b6e2b6de60fbb3f7a0220e21eeee"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "753c668004e087413a7e097c2a931bbacb60df49dd4d146bf0e8a92b0bc62b1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ebd96ffc91838acfb7e6169d5f0045cad3a4ae66745c281305d31e020d5807a"
    sha256 cellar: :any_skip_relocation, catalina:      "e0456536282e8377129017772650a2fbb2624d1483275c740e81d4c342f26134"
    sha256 cellar: :any_skip_relocation, mojave:        "80ab5a7991378bc71e181d26547f22fcda150f7d84b69c75504c9a167435ff5f"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/7b/92/1fe4e6cbd476f33658b854f3bae8e7230481ac0e4f2758385b3a5cd05fe7/astroid-2.5.2.tar.gz"
    sha256 "6b0ed1af831570e500e2437625979eaa3b36011f66ddfc4ce930128610258ca9"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/31/8a/6f5449a7be67e4655069490f05fa3e190f5f5864e6ddee140f60fe5526dd/isort-5.8.0.tar.gz"
    sha256 "0a943902919f65c5684ac4e0154b1ad4fac6dcaa5d9f3426b732f1c8b5419be6"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/bb/f5/646893a04dcf10d4acddb61c632fd53abb3e942e791317dcdd57f5800108/lazy-object-proxy-1.6.0.tar.gz"
    sha256 "489000d368377571c6f982fba6497f2aa13c6d1facc40660963da62f5c379726"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
