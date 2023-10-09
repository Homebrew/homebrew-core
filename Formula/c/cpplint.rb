class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/18/72/ea0f4035bcf35d8f8df053657d7f3370d56ff4d4e6617021b6544b9958d4/cpplint-1.6.1.tar.gz"
  sha256 "d430ce8f67afc1839340e60daa89e90de08b874bc27149833077bba726dfc13a"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47cdfd72fb4b318630749d47cf3d62b0ec3166f8b10a22d1023204e9f267f587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b9975a98abfe54a8cdec7e6ffe0168a8354ee9cda516ae37eb34abad85f044e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf3f954514e234629beed644e97f278ac14705397969598709203d7a40a63c37"
    sha256 cellar: :any_skip_relocation, sonoma:         "16464e4b72e08e17d4ac2570decef4e77e372e6f632314884a42878d116f136c"
    sha256 cellar: :any_skip_relocation, ventura:        "977c30beae305e54454deb965329b67e8b02c84e236b0420cf0c3a69f8e1887a"
    sha256 cellar: :any_skip_relocation, monterey:       "dd5bff564cce083416193e8e81f1bc0b55e82d92b534c3b9dcf3eb31a411d6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85c26fd3ea019e2ba8c946b0d631fd913e780ae556744add5a7c7cf5edc6a7e8"
  end

  depends_on "python@3.12"

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
