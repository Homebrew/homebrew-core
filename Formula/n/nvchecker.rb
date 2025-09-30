class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/e1/74/b8a08017ba9dcf55487a60fc645b7e57c347281da11cd75b5d7584c03faa/nvchecker-2.19.tar.gz"
  sha256 "247c7aca76ce55fb44f1a7718566f8312f473796ae7f4107cd193e1d6dba2883"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f03055f4101334c088c49083d4022c387c60483a26ed244441962959cf6947b7"
    sha256 cellar: :any,                 arm64_sequoia: "8a21fada680024e9c6902bc0c05392587dbe75c8a894f927347bfd70a32193d7"
    sha256 cellar: :any,                 arm64_sonoma:  "0332d79eb933b66ee4c255fe7a2ea8a3b0299a13e82a246ca2d5dbec13855842"
    sha256 cellar: :any,                 sonoma:        "a905c15f9efd5db3fff6e0f55246df17624ecc458fb4e418820630cb9276e3df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff31099770e1304f2570622bbabcf0a9d7593d38f2e46e1c740651cd1140e5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6916fca1971bfbd85dbaacc1d05590d25831b875cb58bd4caba77f1521c07bc1"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
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
