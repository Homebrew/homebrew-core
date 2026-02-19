class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/openstack/bashate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a725f148a93f1daf32f931bdd56959cd7cfbf9030a58f3630b1b48ba90c107a7"
  end

  depends_on "python@3.14"

  pypi_packages extra_packages: "platformdirs"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    venv = virtualenv_install_with_resources

    # Replace vendored platformdirs with latest version for easier relocation
    # https://github.com/pypa/setuptools/pull/5076
    venv.site_packages.glob("setuptools/_vendor/platformdirs*").map(&:rmtree)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bashate --version")

    (testpath/"test.sh").write <<~SHELL
      #!/bin/bash
        echo "Testing Bashate"
    SHELL
    assert_match "E003 Indent not multiple of 4", shell_output("#{bin}/bashate #{testpath}/test.sh", 1)
    assert_empty shell_output("#{bin}/bashate -i E003 #{testpath}/test.sh")
  end
end
