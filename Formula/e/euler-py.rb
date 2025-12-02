class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://files.pythonhosted.org/packages/a6/41/f074081bc036fbe2f066746e44020947ecf06ac53b6319a826023b8b5333/EulerPy-1.4.0.tar.gz"
  sha256 "83b2175ee1d875e0f52b0d7bae1fb8500f5098ac6de5364a94bc540fb9408d23"
  license "MIT"
  revision 3
  head "https://github.com/iKevinY/EulerPy.git", branch: "master"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "6db4a36f8704a74ee7a62cbd6fb742b57b1586b592b0d5d53f6d24e34bb85be5"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    # Unpin old click version: https://github.com/iKevinY/EulerPy/commit/9923d2ee026608e33026909bb95c444724b08ba2
    inreplace "requirements.txt", "click==4.0", "click"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"euler", shell_parameter_format: :click)
  end

  test do
    output = pipe_output("#{bin}/euler", "Y\n", 0)
    assert_match 'Successfully created "001.py".', output
    assert_path_exists testpath/"001.py"
  end
end
