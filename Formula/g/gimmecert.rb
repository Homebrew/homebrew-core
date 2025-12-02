class Gimmecert < Formula
  include Language::Python::Virtualenv

  desc "Quickly issue X.509 server and client certificates using locally-generated CA"
  homepage "https://projects.majic.rs/gimmecert"
  url "https://files.pythonhosted.org/packages/94/b3/f8d0d4fc8951d7ff02f1d3653ba446ad0edf14ab1a18cff4fbe1d1b62086/gimmecert-1.0.0.tar.gz"
  sha256 "eb00848fab5295903b4d5ef997c411fe063abc5b0f520a78ca2cd23f77e3fd99"
  license "GPL-3.0-or-later"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "131301a3467e90afb96224fdccf103949029d5f963f612f3bf5f512f81adbed0"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  # py3.14 build patch
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    output1 = shell_output("#{bin}/gimmecert init")
    assert_match "CA hierarchy initialised using 2048-bit RSA keys", output1

    output2 = shell_output("#{bin}/gimmecert status")
    assert_match "No server certificates have been issued", output2

    assert_path_exists testpath/".gimmecert/ca/level1.key.pem"
    assert_path_exists testpath/".gimmecert/ca/level1.cert.pem"
    assert_path_exists testpath/".gimmecert/ca/chain-full.cert.pem"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 30621bf..8ac3b28 100755
--- a/setup.py
+++ b/setup.py
@@ -24,7 +24,7 @@ from setuptools import setup, find_packages
 
 README = open(os.path.join(os.path.dirname(__file__), 'README.rst')).read()
 
-python_requirements = ">=3.8,<3.13"
+python_requirements = ">=3.8"
 
 install_requirements = [
     'cryptography>=42.0,<42.1',
