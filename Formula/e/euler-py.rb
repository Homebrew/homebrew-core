class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://files.pythonhosted.org/packages/a6/41/f074081bc036fbe2f066746e44020947ecf06ac53b6319a826023b8b5333/EulerPy-1.4.0.tar.gz"
  sha256 "83b2175ee1d875e0f52b0d7bae1fb8500f5098ac6de5364a94bc540fb9408d23"
  license "MIT"
  revision 4
  head "https://github.com/iKevinY/EulerPy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f0b353fae5f2356901a0d33ae8c994f35194bc1a23acd06397b6458e892231c"
  end

  depends_on "python@3.14"

  # Manually updated
  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
