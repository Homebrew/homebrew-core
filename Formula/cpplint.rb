class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/18/72/ea0f4035bcf35d8f8df053657d7f3370d56ff4d4e6617021b6544b9958d4/cpplint-1.6.1.tar.gz"
  sha256 "d430ce8f67afc1839340e60daa89e90de08b874bc27149833077bba726dfc13a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd27cfe1e885629d384959cb649c133ae6f9102522294e68c6ee23732dcc4e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd27cfe1e885629d384959cb649c133ae6f9102522294e68c6ee23732dcc4e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd27cfe1e885629d384959cb649c133ae6f9102522294e68c6ee23732dcc4e5"
    sha256 cellar: :any_skip_relocation, ventura:        "39d32c6b83bba93c843dfd6b3f90a427970212ebc83352b96973f28425e9c6bb"
    sha256 cellar: :any_skip_relocation, monterey:       "39d32c6b83bba93c843dfd6b3f90a427970212ebc83352b96973f28425e9c6bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "39d32c6b83bba93c843dfd6b3f90a427970212ebc83352b96973f28425e9c6bb"
    sha256 cellar: :any_skip_relocation, catalina:       "39d32c6b83bba93c843dfd6b3f90a427970212ebc83352b96973f28425e9c6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e0f14d6f474777b906407a39771c7a0ae66aaf49069079f4852498babffc56"
  end

  depends_on "python@3.11"

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
