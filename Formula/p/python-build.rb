class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/ce/9e/2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19/build-1.2.1.tar.gz"
  sha256 "526263f4870c26f26c433545579475377b2b7588b6f1eac76a001e873ae3e19d"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a02b06273633d165aeb7f3a6f9c799c688e95a3e0e6a99dff4447c0d174b49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a02b06273633d165aeb7f3a6f9c799c688e95a3e0e6a99dff4447c0d174b49c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a02b06273633d165aeb7f3a6f9c799c688e95a3e0e6a99dff4447c0d174b49c"
    sha256 cellar: :any_skip_relocation, sonoma:         "40ca53f82b413997243774f2adf79eb0baa6900d9ed6db87c4269fa8d43f1908"
    sha256 cellar: :any_skip_relocation, ventura:        "40ca53f82b413997243774f2adf79eb0baa6900d9ed6db87c4269fa8d43f1908"
    sha256 cellar: :any_skip_relocation, monterey:       "40ca53f82b413997243774f2adf79eb0baa6900d9ed6db87c4269fa8d43f1908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f685d6de8ad4b0d9779ea800b6c3b4a5f7af3caa5d4b8ea8064dff279fb6906"
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
