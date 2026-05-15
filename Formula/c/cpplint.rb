class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/c5/83/47a9e7513ba4d943a9dac2f6752b444377c91880f4f4968799b4f42d89cc/cpplint-2.0.2.tar.gz"
  sha256 "8a5971e4b5490133e425284f0c566c7ade0b959e61018d2c9af3ff7f357ddc57"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "439258003bfc9b3bc95292234c4e295da040ba5057bd3dcac53204824e3b0caa"
  end

  depends_on "python@3.14"

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
