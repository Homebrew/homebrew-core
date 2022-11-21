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
  depends_on "pygments"
  depends_on "python@3.11"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
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
