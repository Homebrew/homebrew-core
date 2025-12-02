class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/f4/cb/669ed02fbfe17091998f52a7e3326ac276409117ea10a2c36b2a852a22f9/crytic_compile-0.3.11.tar.gz"
  sha256 "d4e2253d5d81ec3a75deb3ab9fc2c2d2db56e835001cf07f3703911d74b56716"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4d3952e6f5972eb1b5f67f3248055e9f8884e3efa8c5ba88b5dd36e59fc8bf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "713ff45ad3dfebf8f627d30befcdf33ac692b0df6523448416648f7739f5ed26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13714d80a9d5d8660d63e1d26e928ef5688738c82de55d79c0aa66642d58c45d"
    sha256 cellar: :any_skip_relocation, sonoma:        "880d89f3308cf6b9feae58ab22ca51933baa7140050b59a10fd8ebdf789f3117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aaf44e7b59b506f366a490ecea7817dd5f70d1d13552302be02c2b20ac4a27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2fc01535d8120273549b841badf9526ea648b023f9f2a5b73f1626677f6feb"
  end

  depends_on "python@3.14"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/a2/b8/c0f6a7d46f816cb18b1fda61a2fe648abe16039f1ff93ea720a6e9fb3cee/cbor2-5.7.1.tar.gz"
    sha256 "7a405a1d7c8230ee9acf240aad48ae947ef584e8af05f169f3c1bde8f01f8b71"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/e0/55/55b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678/solc_select-1.1.0.tar.gz"
    sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_path_exists testpath/"export/combined_solc.json"
  end
end
