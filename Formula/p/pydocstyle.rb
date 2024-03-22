class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/e9/5c/d5385ca59fd065e3c6a5fe19f9bc9d5ea7f2509fa8c9c22fb6b2031dd953/pydocstyle-6.3.0.tar.gz"
  sha256 "7ce43f0c0ac87b07494eb9c0b462c0b73e6ff276807f204d6b53edc72b7e44e1"
  license "MIT"
  revision 1
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ec360acd50933d2848eded9d479931d25f81ea10235d21ec4400669ecf46b14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06e475eb6dcd37d605dfd2f3a8ccf5aa5572892bd1e32c0408c6f443e2bc5e48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93135b8bb66249764784f87bda720d7aa6888d7a8b4a1c8ea6f8ac4f30b6f38a"
    sha256 cellar: :any_skip_relocation, sonoma:         "331782f216f94fcb457da05bb07e716c87e51447bc335926e94971479d981a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b9e922fa45bd73713fedec79771a9288190e22f8e2fe59cfb7e515102d972a"
    sha256 cellar: :any_skip_relocation, monterey:       "967bf915382d42d17c1fb558bc1065835f7c0f2483d7682b681fe15ee54c93c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e9481d4c84b7d0328fa500dfca9acf2898235745391773b2aa85d096d34b10d"
  end

  disable! date: "2023-11-04", because: :repo_archived

  depends_on "python@3.12"

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
