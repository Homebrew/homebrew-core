class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/e6/ab/2950ee964979aa31efb3e0e960f2055d6b1efec5c6239483f88ca6713fc9/nvchecker-2.20.tar.gz"
  sha256 "79cfc9eba3170405db5b1d74475f2e0b539d708c869a7212b40e803e033e0149"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61cd7ebffbb7ccbafa43fc83b0572034c42c70458d5987da07239afb81fabe5b"
    sha256 cellar: :any,                 arm64_sequoia: "0aefa92f8827e6cad2905da0f50f3997c228f66f865ee554f67e5f96816bd60c"
    sha256 cellar: :any,                 arm64_sonoma:  "e6761462bf59bf8e471cf579e0aa127e38c09b533a5186892afc100ea8d77a6b"
    sha256 cellar: :any,                 sonoma:        "4448e060cee80a57f751deccf38f6a685aa60209078f1189b7a556d21d23de87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d781ccc8e1d49e45ce8c63e19e08b28bc2ede7c573d96b4080af10c64ccdfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d143cf969b33ba0638ebfffaa840e26f93c6d316b8a7b921497f5069a8e7372c"
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
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
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
    url "https://files.pythonhosted.org/packages/37/1d/0a336abf618272d53f62ebe274f712e213f5a03c0b2339575430b8362ef2/tornado-6.5.4.tar.gz"
    sha256 "a22fa9047405d03260b483980635f0b041989d8bcc9a313f8fe18b411d84b1d7"
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
