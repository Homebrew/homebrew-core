class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/3c/2d/9867b195c5c9b427e07cfeeb982c56086c00bca13c560e093e4133775635/cpplint-1.5.4.tar.gz"
  sha256 "c5d70711f06a7a8bfdc09bd7a19c13e114e009a70c8dc16caad1e5f0d2f3cc71"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  depends_on "python@3.9"

  # Just for test
  resource "testfixtures" do
    url "https://files.pythonhosted.org/packages/ee/7b/0bcd797f4d75348bd123ef3b5760edef1767a9dd1e3f2e6b2098f51a5102/testfixtures-6.17.1.tar.gz"
    sha256 "5ec3a0dd6f71cc4c304fbc024a10cc293d3e0b852c868014b9f233203e149bda"
  end

  def install
    virtualenv_install_with_resources

    # install test data
    (share/"test/").install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    output = shell_output("#{bin}/cpplint #{share}/test/samples/v8-sample/src/interface-descriptors.h", 1)
    assert_match "Total errors found: 2", output
  end
end
