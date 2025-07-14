class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/92/91/88bb55225046a2ee9c2243d47346c78d2ed861c769168f451568625ad670/doc8-2.0.0.tar.gz"
  sha256 "1267ad32758971fbcf991442417a3935c7bc9e52550e73622e0e56ba55ea1d40"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea5ecd047b0f0a808eaa97c58b46d254a6d4b92738542c204262db7573fc95b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea5ecd047b0f0a808eaa97c58b46d254a6d4b92738542c204262db7573fc95b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea5ecd047b0f0a808eaa97c58b46d254a6d4b92738542c204262db7573fc95b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a8a1336329a659d6aa33f2876097010f0b8405a2305ec15de51b31e2510a0e4"
    sha256 cellar: :any_skip_relocation, ventura:       "1a8a1336329a659d6aa33f2876097010f0b8405a2305ec15de51b31e2510a0e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c14c67e6b2965fb8a9e793573256cb9ebcdedd08cc7ca305eb41d5c916a465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90c14c67e6b2965fb8a9e793573256cb9ebcdedd08cc7ca305eb41d5c916a465"
  end

  depends_on "python@3.13"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/01/d2/510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935/pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/28/3f/13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470/stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.rst").write <<~EOS
      Heading
      ------
    EOS
    output = pipe_output("#{bin}/doc8 broken.rst 2>&1")
    assert_match "D000 Title underline too short.", output
  end
end
