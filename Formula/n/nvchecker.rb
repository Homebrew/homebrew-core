class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/e6/ab/2950ee964979aa31efb3e0e960f2055d6b1efec5c6239483f88ca6713fc9/nvchecker-2.20.tar.gz"
  sha256 "79cfc9eba3170405db5b1d74475f2e0b539d708c869a7212b40e803e033e0149"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bca1850cccbe81c6a15eb58b0e5d9946dcf8040c201ea181358621ea3bb7577"
    sha256 cellar: :any,                 arm64_sequoia: "4fa7d164d186be639e5c6291e52cfa548ee0af0fae7e107601229f8983a13a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "832c14f48d73dab8c7d2ee6bafe1c5d1897b23d53c9c283d5c9f2cc3b7688f3d"
    sha256 cellar: :any,                 sonoma:        "499b438420acb117d89f6cc0b2cb19a8167b1b3d87cc3c916f77e91edee19570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6924516ae78fbed84bee02e88866c7eaff317fae1945e1469f40d090a3a9552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebfea056a82946370572ad1443e5cf25663f38ae58b54136a995b53b4e1ef4a7"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e3/3d/01255f1cde24401f54bb3727d0e5d3396b67fc04964f287d5d473155f176/pycurl-7.45.7.tar.gz"
    sha256 "9d43013002eab2fd6d0dcc671cd1e9149e2fc1c56d5e796fad94d076d6cb69ef"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/ef/52/9ba0f43b686e7f3ddfeaa78ac3af750292662284b3661e91ad5494f21dbc/structlog-25.5.0.tar.gz"
    sha256 "098522a3bebed9153d4570c6d0288abf80a031dfdb2048d59a49e9dc2190fc98"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/f8/f1/3173dfa4a18db4a9b03e5d55325559dab51ee653763bb8745a75af491286/tornado-6.5.5.tar.gz"
    sha256 "192b8f3ea91bd7f1f50c06955416ed76c6b72f96779b962f07f911b91e8d30e9"
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
