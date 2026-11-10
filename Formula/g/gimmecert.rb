class Gimmecert < Formula
  include Language::Python::Virtualenv

  desc "Quickly issue X.509 server and client certificates using locally-generated CA"
  # Original homepage `https://projects.majic.rs/gimmecert` is down
  homepage "https://github.com/azaghal/gimmecert"
  url "https://files.pythonhosted.org/packages/aa/7e/30e458ef1fa9cb5de414294d9990538c4e3b1faa4ac5ca8f1926c3633455/gimmecert-2.0.0.tar.gz"
  sha256 "3887e8f41067fba232c9be5525c3b541966314e1fd20c8c4c1fdc6f05c296b3e"
  license "GPL-3.0-or-later"
  head "https://github.com/azaghal/gimmecert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b05dc239a921ac47ef10829bdfe96e1e9b5cbb13e6c8b219c9612f851188691"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

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
