class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/e7/1d/6965acf4f85495956ebdb80ab2cafd803e39ba866b8370618a120d72938b/cpplint-2.0.0.tar.gz"
  sha256 "330daf6bf9a9006b9161af6693661df8f8373d54b2ea6527cd515a8e61d41abb"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e54c0d69ee5326844ebd9b9c1f6278292c7c7bea77b589b3dba81a25ce8cbf0b"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    test_file = pkgshare/"samples/v8-sample/src/interface-descriptors.h"
    output = shell_output("#{bin}/cpplint #{test_file} 2>&1", 1)
    assert_match "Total errors found: 2", output
  end
end
