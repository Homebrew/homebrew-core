class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/18/72/ea0f4035bcf35d8f8df053657d7f3370d56ff4d4e6617021b6544b9958d4/cpplint-1.6.1.tar.gz"
  sha256 "d430ce8f67afc1839340e60daa89e90de08b874bc27149833077bba726dfc13a"
  license "Apache-2.0"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d40b696645ffe9e48472a8b705b0bd06c44b56f762881d48455b436e4271396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c2ed51f4ac77f7c56b0d0f4e71e202adb295c407f582ad33ed7288c2ddb5ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94bf09c685fd1271693233ff52c0b87fc49a0802b3a57408a27497d623f36b26"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5d503ab4c4013f67f85435a2581c8856acfc43bec291c0b24b7c5ac9a14fbc2"
    sha256 cellar: :any_skip_relocation, ventura:        "d51ecb560de169b44305d8219489ac73e5acc892f360d19c489c1502e592c5d1"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e15ab4e5e4b0c013625686b944e033d1660051c585f68f40472f67758ee6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0fe2cc9f6d88a1a56620aa0b075d964a6c8add35d2f384631a020f208a38e0"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

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
