class Py7zr < Formula
  include Language::Python::Virtualenv

  desc "7-zip in Python"
  homepage "https://github.com/miurahr/py7zr"
  url "https://files.pythonhosted.org/packages/d6/31/d5469ec310b57c730785068c227caf2263391be846ae5e99488f69b394eb/py7zr-1.1.4.tar.gz"
  sha256 "7674697559bd06b697bf6e8249985cee6dc704a4b07b8e11f24d0b1695707c3e"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/miurahr/py7zr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3fc40d3821676e4258cf6f4aa25b530a194c64a7e83fea7f788a1ab1bd089cde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c851f016a5d219506dd234f22f3d2e2fac03ba403a586d425b59447b11e4f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c559fd0fd37ec78e1be22747f598255e67ab963f8088ea17edc3863035e7ec2"
    sha256 cellar: :any,                 arm64_linux:       "66974bbdabd725f686af36b5efcba39d693dff14cb1f53cf0fb9fc96e5422c93"
    sha256 cellar: :any,                 x86_64_linux:      "bd6c352204448d0b47fe67680852a05c3f05db50b5aa5d104c271f4d48975f66"
  end

  depends_on "python@3.15"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/3e/f3/41bb2901543abe7aad0b0b0284ae5854bb75f848cf406bf8a046bf525f67/inflate64-1.0.4.tar.gz"
    sha256 "b398c686960c029777afc0ed281a86f66adb956cfc3fbf6667cc6453f7b407ce"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/14/c9/e2de4f98c21f2ff9e58047395b6a8e17701a0f2977f0e63f80948f61647f/pybcj-1.0.8.tar.gz"
    sha256 "6818270692912d47e81ccd777b7d0ed2ad3a19ef7aaead3735b38048c80bf368"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/81/d7/803232913cab9163a1a97ecf2236cd7135903c46ac8d49613448d88e8759/pyppmd-1.3.1.tar.gz"
    sha256 "ced527f08ade4408c1bfc5264e9f97ffac8d221c9d13eca4f35ec1ec0c7b6b2e"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/03/19/9590fd39a668ea0a0869493441fe65852246a3ec67616877baad98bcb039/texttable-1.7.2.tar.gz"
    sha256 "dc16ea6b35fbf5291ba6ef79d79e37d9b3ca6acd7bae3ca3450488d7c2e19c99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/py7zr --version")

    (testpath/"test.txt").write("Homebrew")
    system bin/"py7zr", "c", "test.7z", "test.txt"
    rm testpath/"test.txt"
    assert_match "Everything is Ok", shell_output("#{bin}/py7zr t test.7z")
    system bin/"py7zr", "x", "test.7z"
    assert_path_exists testpath/"test.txt"
  end
end
