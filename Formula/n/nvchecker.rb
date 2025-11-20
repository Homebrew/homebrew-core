class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/e1/74/b8a08017ba9dcf55487a60fc645b7e57c347281da11cd75b5d7584c03faa/nvchecker-2.19.tar.gz"
  sha256 "247c7aca76ce55fb44f1a7718566f8312f473796ae7f4107cd193e1d6dba2883"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a8618b16390f9b5ec17e807a0919cd56640108fbbe761a1b3ae466112de3f66c"
    sha256 cellar: :any,                 arm64_sequoia: "25d88546c21293037867d79d0c5dc2454be8e2e5e4b3e216f06eb84944347e4a"
    sha256 cellar: :any,                 arm64_sonoma:  "e75f82e2d200d9cdd27a7e0b12f54cee48208d22ad563477915088b25643cfbb"
    sha256 cellar: :any,                 sonoma:        "a28b5f6a568a2b676e083bc03da732a6d163c5f087a6d61dc0622843cf7c8c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3a126a9e804fcec5dbbaa41b8d800a23a48a24f128eab56ebe78d1e2e9342e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51b1838ef2e3709866d15ba400318e89f92c88018c22d4643f74d0eee8bed68e"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e3/3d/01255f1cde24401f54bb3727d0e5d3396b67fc04964f287d5d473155f176/pycurl-7.45.7.tar.gz"
    sha256 "9d43013002eab2fd6d0dcc671cd1e9149e2fc1c56d5e796fad94d076d6cb69ef"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/79/b9/6e672db4fec07349e7a8a8172c1a6ae235c58679ca29c3f86a61b5e59ff3/structlog-25.4.0.tar.gz"
    sha256 "186cd1b0a8ae762e29417095664adf1d6a31702160a46dacb7796ea82f7409e4"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/09/ce/1eb500eae19f4648281bb2186927bb062d2438c2e5093d1360391afd2f90/tornado-6.5.2.tar.gz"
    sha256 "ab53c8f9a0fa351e2c0741284e06c7a45da86afb544133201c5cc8578eb076a0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
