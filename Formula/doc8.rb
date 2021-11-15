class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/76/04/3f70faf4ad8d9bcc5f6a2ee27e4cad48fd3a1ed80f3ce40fc9334f268e2d/doc8-0.10.1.tar.gz"
  sha256 "376e50f4e70a1ae935416ddfcf93db35dd5d4cc0e557f2ec72f0667d0ace4548"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3899ff9e0fda13a433015a2f5309d3f2477c78e6e2798713420340645c716909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b90d196888743f9f9c8410dc7f55c5e713d02d84bd5283f3b750657d9c5e50c1"
    sha256 cellar: :any_skip_relocation, monterey:       "f50a2ce5fdb1cdb9691e0fa6e632dfa5471c6c0a807cd51cae51c2c0e0fbbe61"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b3d14f8ecb4356eb55f28ee566e3e418f8fae8a2ba52efeba23033abc69f86"
    sha256 cellar: :any_skip_relocation, catalina:       "f07d4456b1d8b5f272f1d05754f7074cea76741c31e4cd8dc941bb09bd23c9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "040d934c7cac72e0ccc2b7591a11b5d7867e768d2bd0247d15bd1b8b7ec6af92"
  end

  depends_on "python@3.10"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/61/d7/8b2786f10b73e546aa9a85c2791393a6f475a16771b8028c7fb93d6ac8ce/docutils-0.18.tar.gz"
    sha256 "c1d5dab2b11d16397406a282e53953fe495a46d69ae329f55aa98a5c4e3c5fbb"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/69/7e/e420b9b6b06f9597827571e871f9492512701497971a4cf3f4638c03bc7a/pbr-5.7.0.tar.gz"
    sha256 "4651ca1445e80f2781827305de3d76b3ce53195f2227762684eb08f17bc473b7"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/45/69/5e43d0e8c2ca903aaa2def7f755b97a3aedc5793630abbd004f2afc3b295/restructuredtext_lint-1.3.2.tar.gz"
    sha256 "d3b10a1fe2ecac537e51ae6d151b223b78de9fafdd50e5eb6b08c243df173c80"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
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
