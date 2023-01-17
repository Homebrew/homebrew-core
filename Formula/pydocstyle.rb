class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/e9/5c/d5385ca59fd065e3c6a5fe19f9bc9d5ea7f2509fa8c9c22fb6b2031dd953/pydocstyle-6.3.0.tar.gz"
  sha256 "7ce43f0c0ac87b07494eb9c0b462c0b73e6ff276807f204d6b53edc72b7e44e1"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba6ce163705327fbd2b8d5d469b40aef4f26c3314c7e0cbaca1b444cce29c82f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d45ab668c8960844c11cb09b27a903fed80ba62e6826c18bb421b7a04addf29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b40ff7ea2f9094e4e16a35e1d6164175b263ab491104c7df50728aab63a44a8"
    sha256 cellar: :any_skip_relocation, ventura:        "58acd740028ef0c9d22408e2f78cb5828423a71f2997eb780e1539ff6d6baf8a"
    sha256 cellar: :any_skip_relocation, monterey:       "f3407b3e708a443e84844495550005d6f1d984f848b81d0cdc020c7a946cf864"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a3c98ae639ebf106d990055492928e3eddbdb9cc958d5867d665d1f88f7764c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b074dfc152fd34719adddd24c2513af734cb5a9cd900c1d5d375311d996429b5"
  end

  depends_on "python@3.11"

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring():
        """  extra spaces  """
        pass
    EOS
    output = pipe_output("#{bin}/pydocstyle broken.py 2>&1")
    assert_match "No whitespaces allowed surrounding docstring text", output
  end
end
