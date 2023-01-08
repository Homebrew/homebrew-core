class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/1e/b6/7d1de9e068d5804222698086295363cd8fb99c79146c59431058c9c17150/pydocstyle-6.2.3.tar.gz"
  sha256 "d867acad25e48471f2ad8a40ef9813125e954ad675202245ca836cb6e28b2297"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "654f333e6304ffba9e09d99f51b3882376e5aa3c4dfd521e6073206e596f3475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72348ad6faf1044232db2b683f41ef6c3416637a7525dcb080222c3a69d9bc97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bd58d05c6004807e84421697423fcaaa5bef52054f287ae8b4df9f32681b79f"
    sha256 cellar: :any_skip_relocation, ventura:        "17af567a5d436ba07c9c8aaf6642aa77d82a92f10585b06048af46b3aec0f5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e0997af7f422971b07e1bfc630131595df3c6ba2c7d7f3c6ef540dc9f7e47ccd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ede4f4a8bd6208a38bb664afc65602586a7155f42c7708a0e7e9722079e3576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78fbd35136195e512cb2d2630cb819c59a0098c0b7f55aee4b71dae3023af73"
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
