class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/18/72/ea0f4035bcf35d8f8df053657d7f3370d56ff4d4e6617021b6544b9958d4/cpplint-1.6.1.tar.gz"
  sha256 "d430ce8f67afc1839340e60daa89e90de08b874bc27149833077bba726dfc13a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e4909f4e4f917b642a3f3fbca24eac07a1fa383bff44d3f8f8a789c71b8425"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5e4909f4e4f917b642a3f3fbca24eac07a1fa383bff44d3f8f8a789c71b8425"
    sha256 cellar: :any_skip_relocation, monterey:       "e453098f9d51ea4ea5869aafc40ad7601ecb01476021008830529a5c463d6689"
    sha256 cellar: :any_skip_relocation, big_sur:        "e453098f9d51ea4ea5869aafc40ad7601ecb01476021008830529a5c463d6689"
    sha256 cellar: :any_skip_relocation, catalina:       "e453098f9d51ea4ea5869aafc40ad7601ecb01476021008830529a5c463d6689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f63a058d78a8f2fb9434afb9760c46d879316ac8d577730e1eb77df7f107ff"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    output = shell_output("#{bin}/cpplint #{pkgshare}/samples/v8-sample/src/interface-descriptors.h", 1)
    assert_match "Total errors found: 2", output
  end
end
