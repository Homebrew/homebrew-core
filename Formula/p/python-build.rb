class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/42/18/94eaffda7b329535d91f00fe605ab1f1e5cd68b2074d03f255c7d250687d/build-1.4.0.tar.gz"
  sha256 "f1b91b925aa322be454f8330c6fb48b465da993d1e7e7e6fa35027ec49f3c936"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "375e662f81dc2fe0204394290fa67d0eafb46704ee426ff5483ea0aa90e43ad7"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system bin/"pyproject-build"
      assert_path_exists Pathname.pwd/"dist/build-#{stable.version}.tar.gz"
      assert_path_exists Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl"
    end
  end
end
