class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/a9/c4/dc00e42c158fc4dda2afebe57d2e948805c06d5169007f1724f0683010a9/isort-5.12.0.tar.gz"
  sha256 "8bef7dde241278824a6d83f44a544709b065191b95b6e50894bdc722fcba0504"
  license "MIT"
  revision 1
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a6fe0fa7fff82ad3f77066d49102cac7ced09f0431fe7c34ef4db390c2de8b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "766a9c948c66313d18af5adeb24c2c55a7cd5f8419490e65846457535451c26a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abf6cbbe5fee719854f6438726a39f358fdd623889948903fead3222f363e37f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c77093fe5ec5a3bf45df36a6eb761a304fef472adf4bab0c0d43d34b17bca813"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb28d5ebec41304551a8eaa70c69a21e5fe6099303d84d9ad96614c9b561f7b"
    sha256 cellar: :any_skip_relocation, monterey:       "1d076d14e42b27fd509c01555439c83e3ae59d24ba4a5c20aeeb66781925a300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be81f88db2b0136b2dd8803a5b6bd4c23b04b6f2f77337b22bb5fb50eb662d7d"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
