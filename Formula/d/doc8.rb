class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/92/91/88bb55225046a2ee9c2243d47346c78d2ed861c769168f451568625ad670/doc8-2.0.0.tar.gz"
  sha256 "1267ad32758971fbcf991442417a3935c7bc9e52550e73622e0e56ba55ea1d40"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b245ad59690256035fa27e2e98202870938e1d058c6ead2c46406cc64216db17"
  end

  depends_on "python@3.15"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/ca/e6/eefcad2228f4124f17e01064428fbcd0ade06a274f3063ce3a126a569d6b/restructuredtext_lint-2.0.2.tar.gz"
    sha256 "dd25209b9e0b726929d8306339faf723734a3137db382bcf27294fa18a6bc52b"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.rst").write <<~RST
      Heading
      ------
    RST
    output = pipe_output("#{bin}/doc8 broken.rst 2>&1")
    assert_match "D000 Title underline too short.", output
  end
end
