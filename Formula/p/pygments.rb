class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
  sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40ec7beb2d56754d8ec79fecd4b7963c6e05b6c9e1001ed192605ab19986e7ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c114a64ba41db6a64a2f92b257cc3e3c988a40aac2b7d306f8a6200c4b5b8a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "577d7ce6cb1dcbb0641a6b5cbd21d60cd2e0b8e8f467fee8cc53bb4d6c292079"
    sha256 cellar: :any_skip_relocation, sonoma:         "b36ed97912d3aec051498d0e55b0f61f223b4dd5c0b3c1117f9a25658e82265c"
    sha256 cellar: :any_skip_relocation, ventura:        "67d2f74e82aa30f5bb98ca430ef9025fd6b4ea6d945d439482c976b38cf8ee74"
    sha256 cellar: :any_skip_relocation, monterey:       "f61142967d6d7fdc0c00c859b636b6b85e6ed951484b202e3ee6b4ab4afbb59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec0f74801c5e763881c5632f9e3e4dc3ec392b08442fe6c8f492194f72c0432"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_predicate testpath/"test.html", :exist?
  end
end
