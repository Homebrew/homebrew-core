class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/54/f8/6833fb37702900711e5617e0594e2eeccbb0b716993e84b00ee186907e1c/crytic-compile-0.3.7.tar.gz"
  sha256 "c7713d924544934d063e68313da8d588a3ad82cd4f40eae30d99f2dd6e640d4b"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9eab5446b3457896b0a1a1886fd48371b883a42e7fbd89b62c4c3d9ab43cc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd34137de9addf44c5e35574d9735faff091559f730dd3cea10d60319ab8179c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa637f9a29728f4c89344c08680be186a62e3ca82a43fce597e41ce187e91dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "a386fa83213174fba2f12477297f8152d82f8f04132b0c519cff9bdecdfcf4da"
    sha256 cellar: :any_skip_relocation, ventura:       "ab1c4a74e503eadd2d5211c058f615a18f025ec1c2e79baa84676ce184cb78af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c61f5e2019748456d8a0586e1bac5b8e2e932e8955ac2de2c28b125df5f331"
  end

  depends_on "python@3.13"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/e4/aa/ba55b47d51d27911981a18743b4d3cebfabccbb0598c09801b734cec4184/cbor2-5.6.5.tar.gz"
    sha256 "b682820677ee1dbba45f7da11898d2720f92e06be36acec290867d5ebf3d7e09"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/13/52/13b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6/pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "solc-select" do
    url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
    sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
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

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
