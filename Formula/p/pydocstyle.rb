class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/e9/5c/d5385ca59fd065e3c6a5fe19f9bc9d5ea7f2509fa8c9c22fb6b2031dd953/pydocstyle-6.3.0.tar.gz"
  sha256 "7ce43f0c0ac87b07494eb9c0b462c0b73e6ff276807f204d6b53edc72b7e44e1"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dce81096e008f94f5f66adc15acee7060452a46b8e9ec2f8125b92c26cb17732"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ded273a89181fc24508db6ac20fc5209cc79ad923e2106e3de7e889b59711d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4eb0b044ac8618e1b641ce53914c4e637d7b4dda414ff8f7f0ecff914278ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51de6784ad7eacf7e71abfd0a009566881fdcd97db71dcc9aa2b78b7c96f40c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa208b1bedff1664c6bc851c22428831eb44c0f2cfe97692c61eaf4ba698585a"
    sha256 cellar: :any_skip_relocation, ventura:        "0ef946f3ac8f8d1c805d010b207d55c691d795ef365e65eae8d82f32dbf8be91"
    sha256 cellar: :any_skip_relocation, monterey:       "9b145d7b416f4274d592aaa309659bbf5f535bfb2d6351017af9cf0b5b86acb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "66422fa848a63b8c185db46bde38ad09d2a7bd9954294d3408a6bb6b3c417f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5028fbde0c073b5929daabb7fca939454809943f98fb5e15076899883277a4"
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
