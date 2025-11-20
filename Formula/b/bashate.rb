class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack/bashate"
  url "https://files.pythonhosted.org/packages/4d/0c/35b92b742cc9da7788db16cfafda2f38505e19045ae1ee204ec238ece93f/bashate-2.1.1.tar.gz"
  sha256 "4bab6e977f8305a720535f8f93f1fb42c521fcbc4a6c2b3d3d7671f42f221f4c"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "3599931c38b9118981d0e25270b4b625b998f7b88a37d9579115be3f1547beeb"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.14"

  pypi_packages exclude_packages: "setuptools"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/ad/8d/23253ab92d4731eb34383a69b39568ca63a1685bec1e9946e91a32fc87ad/pbr-7.0.1.tar.gz"
    sha256 "3ecbcb11d2b8551588ec816b3756b1eb4394186c3b689b17e04850dfc20f7e57"
  end

  def install
    virtualenv_install_with_resources
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
