class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/b7/c7/01674c093a29cc83261d2cd554dd9d0debf8cfad061c05359a5d18562863/pydocstyle-6.2.1.tar.gz"
  sha256 "5ddccabe3c9555d4afaabdba909ca2de4fa24ac31e2eede4ab3d528a4bcadd52"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee06d3bd641327e0df55963fa898cf326ea0078633d97dfb2ce1ac7135e7bd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281c7a1b2aca5d293724af8c0bf4eaf5fb6acae3bb6e90b6544399879c1531ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53c853042653f2189d096f3470c10725ff43599be7c569cf688cc242b1ad6c42"
    sha256 cellar: :any_skip_relocation, ventura:        "3ced7d900552304d01ad0a1ed0473435082a70898d40e879a2fb1a77afe6ad69"
    sha256 cellar: :any_skip_relocation, monterey:       "59717b9bb27f945289f9f75dad090aae52f9e27cbd86a39c3c426436bce6bf89"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77714137b6c87b1b69e6dd47d9977e71150119eaf1f79b23c9176661936414a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6155c6752c97e736f54919b0320a902204b37e0583051bd73ae861e16954008"
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
