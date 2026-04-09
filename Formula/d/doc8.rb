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
    sha256 cellar: :any_skip_relocation, all: "7d4573d3ab94153d219dbb6b880afe137ef540fe236de2c44278c4d7829cf705"
  end

  depends_on "python@3.14"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/ca/e6/eefcad2228f4124f17e01064428fbcd0ade06a274f3063ce3a126a569d6b/restructuredtext_lint-2.0.2.tar.gz"
    sha256 "dd25209b9e0b726929d8306339faf723734a3137db382bcf27294fa18a6bc52b"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/a2/6d/90764092216fa560f6587f83bb70113a8ba510ba436c6476a2b47359057c/stevedore-5.7.0.tar.gz"
    sha256 "31dd6fe6b3cbe921e21dcefabc9a5f1cf848cf538a1f27543721b8ca09948aa3"
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
