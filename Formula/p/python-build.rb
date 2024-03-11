class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/55/f7/7bd626bc41b59152248087c1b56dd9f5d09c3f817b96075dc3cbda539dc7/build-1.1.1.tar.gz"
  sha256 "8eea65bb45b1aac2e734ba2cc8dad3a6d97d97901a395bd0ed3e7b46953d2a31"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dde0b5098ea5170eb38a840b8694226dc95b8d7335ddd951272e8ac89370c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd4b18fdafb6e35d5ef81e96ec0d5000f07bc8eb9fc4adef8917c6f6643a1cea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79c18e9bc6934f28c1d5ebe6572ca48dc84df07f069d21e5cd98049f6b7c6e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a529c8790b61d34289c2ef568eb35a959aa4911bddb1b66717718dbf728329bc"
    sha256 cellar: :any_skip_relocation, ventura:        "53f6e2ed99bbededb4daf1e8eeee91bc7fde98b81a43439ef8e102a360cde1c0"
    sha256 cellar: :any_skip_relocation, monterey:       "66acc82e67057fc9f6b472f8fcfa54d41415b975a6d1acc6551c2942e7c77542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b35abfa8a384e706955fadf27e3abed1e327ce52761d6d4e8ad532a120cb66"
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
