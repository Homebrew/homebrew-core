class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/3b/1f/577263ba18254578b7235b2b1ea55e1a62ca537d3acfc3033e93a9631759/dynaconf-3.2.5.tar.gz"
  sha256 "42c8d936b32332c4b84e4d4df6dd1626b6ef59c5a94eb60c10cd3c59d6b882f2"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea284ee8d0e1cd983f62d60ffbbaa64e0bd99584a695ecd4d38b5f0c1605baed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e93e5cd441b0512d12c131d036f4b9a063880595e6f1f2a1a18865263e82690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e309fd6e7922e34feb53d0760362d5eab6b4887f626c05e8dcc0285b1de18a95"
    sha256 cellar: :any_skip_relocation, sonoma:         "b21eefc850000cfd4af2fc50d37cc6bd1b23515995e13838a98499da2f536a06"
    sha256 cellar: :any_skip_relocation, ventura:        "b96734f90e5ae1546b56bec927ea2c25cb2fc09db7f61972b26663c3d3537ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "5d59e2f06e5f26bd59b0ceced8d39f9f36a0bf59835cd644ee769e60805fc2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad67495af56194247e98dfbd86c45032be4adf19785db9ab76ed37595a4208d"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
