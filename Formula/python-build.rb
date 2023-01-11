class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/de/1c/fb62f81952f0e74c3fbf411261d1adbdd2d615c89a24b42d0fe44eb4bcf3/build-0.10.0.tar.gz"
  sha256 "d5b71264afdb5951d6704482aac78de887c80691c52b88a9ad195983ca2c9269"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627b7ce96d4cc4bb54072f1348a1159ce7bd93bd1909d72e0797e23822360729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4bad095b425f11e26daa8450d716d6d3d87a6b086fa93e746e42b2b5edca4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f734c014c744750da9b3ff86252ccc04830b22219dadcc7705edb6e2426357cc"
    sha256 cellar: :any_skip_relocation, ventura:        "3eef3b41a48887701c20d382613226d4b6066bf3e1149c0fe1adf1ab013b1542"
    sha256 cellar: :any_skip_relocation, monterey:       "f687f81100265c55552369fa8da87af664b6a126570b7eb0cacc0f5d82f14eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "63acd4ceb75a08030b0be6868d99e5fb27f10397601161b107ef0be218a28601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "547a0ff2639a4eddba12c058af02c73b1df8a63c46f316005c756a76fbb8a82d"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyproject_hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system "pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end
