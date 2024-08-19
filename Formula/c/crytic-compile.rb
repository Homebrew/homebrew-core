class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/54/f8/6833fb37702900711e5617e0594e2eeccbb0b716993e84b00ee186907e1c/crytic-compile-0.3.7.tar.gz"
  sha256 "c7713d924544934d063e68313da8d588a3ad82cd4f40eae30d99f2dd6e640d4b"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1c3595a2496d3e4144602edf23c60531fa1dc9ab3169302c9e5d304a5409533"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480d968b69cd6d51808292c5625652b27032617db87fb053306b657b4c9f96ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b3b28b863710ca2bab911ddbd198c434870d0df4f578bb5a91dd6b56184a076"
    sha256 cellar: :any_skip_relocation, sonoma:         "2635e483dab925dd75dda0b9b00c6880400f10bbd9651d692dee302129642f73"
    sha256 cellar: :any_skip_relocation, ventura:        "b7c64cb65ef2b4519557617edfb99b32f471b184f5b7c65078e53e504686d8cc"
    sha256 cellar: :any_skip_relocation, monterey:       "21669063737bf6536e3d9885d1b954f006bd581420c70f7b25e3ed362036f385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7c35db876889ab8dc97a74dce861690d047a2eb235b5265763b931e0c48e2b"
  end

  depends_on "python@3.12"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/ca/39/0d0a29671be102bd0c717c60f9c805b46042ff98d4a63282cfaff3704b45/cbor2-5.6.2.tar.gz"
    sha256 "b7513c2dea8868991fad7ef8899890ebcf8b199b9b4461c3c11d7ad3aef4820d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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
