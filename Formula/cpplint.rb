class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://github.com/cpplint/cpplint/archive/1.5.4.tar.gz"
  sha256 "e254b5620fb039689b8f5e64b07384ee53beb695304c5c01195133be662b4457"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint 1.5.4", output.strip
  end
end
