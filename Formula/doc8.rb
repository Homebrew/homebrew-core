class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/75/8b/6df640e943a1334bebaf96e0017911763d882748e8b8fd748f109c8c3279/doc8-1.0.0.tar.gz"
  sha256 "1e999a14fe415ea96d89d5053c790d01061f19b6737706b817d1579c2a07cc16"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c770e05a108e339b5a8c1b5686cf7a4eb43970d7f77394b8b25733505f7ae170"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5966a09aa8b12036dcfc6eff9d92ca74089219c9424a50d81c15b5037449b3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b4f75328d8507956d57e47534b3a4176236c35467476d6170223238c0a48041"
    sha256 cellar: :any_skip_relocation, monterey:       "9d463df5a246c5fc0d7f202059ecd886b04b02c4346204491cc14f2d1eaeddb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbabd03057249afaf7362b715d6db3d2663e75d93b252e43d728d4190d9de463"
    sha256 cellar: :any_skip_relocation, catalina:       "8ed78fe92a078f8633f4b35863b826227948a80b6ba22569c4f0e4bdf148bfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e94c50d22f8cc5781ab9a30b6488ecf6843530a4aeb29866a921a8b0177edc4"
  end

  depends_on "docutils"
  depends_on "python@3.11"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/96/9f/f4bc832eeb4ae723b86372277da56a5643b0ad472a95314e8f516a571bb0/pbr-5.9.0.tar.gz"
    sha256 "e8dca2f4b43560edef58813969f52a56cef023146cbb8931626db80e6c1c4308"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/f5/70/7953626fd19faa7a0852779c1949650e825f650ee6060f68658a84584c26/stevedore-4.0.0.tar.gz"
    sha256 "f82cc99a1ff552310d19c379827c2c64dd9f85a38bcd5559db2470161867b786"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
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
