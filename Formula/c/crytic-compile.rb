class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/76/07/b629a6bf2c56f63bb6cd1b2000e58395642dcd72ebae746282a58c0feb3f/crytic-compile-0.3.6.tar.gz"
  sha256 "9a53c8913daadfd0f67e288acbe9e74130fe52cc344849925e6e969abc1b8340"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be612b0daababddbff1ed5f046f1be997d47fe55765f9bcd1e37bbabd2ab775c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af421a8964d42cdaac43ee1b9da5f3337236a7fe8406b5e0a3c26d3bcdc6faf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b8a552b98d3aede71ce49ed442d3e3fa3ff8f09235a7c0412eac5a62d10712"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ea40c94787dbf1ae62ed313031b6ebe034894edb3b93b2f2cb04daa0ae24bcd"
    sha256 cellar: :any_skip_relocation, ventura:        "5f2e53bcf27c14cd1ec5870e3573b678cf0fe68377c3a172332b03e1d4d4a5bc"
    sha256 cellar: :any_skip_relocation, monterey:       "e41ccdab19068087bffbafeb723084d925fb440286d00dd5a663c0a51c8a55e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6b16c484a0edd03f6ab939dccf46479b8b38b78a6858788f210bdb171172b5f"
  end

  depends_on "python@3.12"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/ca/39/0d0a29671be102bd0c717c60f9c805b46042ff98d4a63282cfaff3704b45/cbor2-5.6.2.tar.gz"
    sha256 "b7513c2dea8868991fad7ef8899890ebcf8b199b9b4461c3c11d7ad3aef4820d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
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
