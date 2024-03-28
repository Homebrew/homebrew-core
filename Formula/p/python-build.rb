class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/23/fc/e3dd5750d16be3e98ea200d8f6b143221d54567d2f08ea181efb686f9948/build-1.2.0.tar.gz"
  sha256 "49df7f8e1e74d345fe71e54f5d56423b2111eda89e3da53a2c18392954dade1d"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7cf2f0431b83814aac5d459f04fe5fae420fb990933bf695c6c29f478a1e002"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7cf2f0431b83814aac5d459f04fe5fae420fb990933bf695c6c29f478a1e002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7cf2f0431b83814aac5d459f04fe5fae420fb990933bf695c6c29f478a1e002"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f4cb17cda361497cffbd7dcdf81e497a56aef12359f83570b2fbe29ef2cfce"
    sha256 cellar: :any_skip_relocation, ventura:        "12f4cb17cda361497cffbd7dcdf81e497a56aef12359f83570b2fbe29ef2cfce"
    sha256 cellar: :any_skip_relocation, monterey:       "12f4cb17cda361497cffbd7dcdf81e497a56aef12359f83570b2fbe29ef2cfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c20c6e2a28bf1e786ad3b488afd089d7a54d6859182181cd2746ce08d535e6d3"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system bin/"pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end
