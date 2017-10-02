class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/willthames/ansible-lint/"
  url "https://files.pythonhosted.org/packages/f1/5d/0f92a80f28071e79de117424d36e2b05b17d965f74519dc3c59a4bc56124/ansible-lint-3.4.16.tar.gz"
  sha256 "0339e28e4c772ff2c963ebb06650fa38430eca8d8afd524de08aacb676799ff9"

  bottle do
    cellar :any
    sha256 "c4292d355b81547a6974b3086700eff7f849503d161caf9c959b032de6661d46" => :high_sierra
    sha256 "ea892ba142dce5a728a5ab6ff737e9c81612debe37551fbdd83a9623eb8dd88f" => :sierra
    sha256 "bca9f1546ba403987cff24ed7039f0a189719e1ac57caa1e69162a4755510b07" => :el_capitan
    sha256 "2e82443e7065c2b155bdab484022162beab9a56a3e7a4bb3361fb73192526abb" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python
  depends_on "libyaml"
  depends_on "openssl@1.1"

  resource "ansible" do
    url "https://files.pythonhosted.org/packages/1e/7c/385ccbeb0fbefc13eaef53df76e42ef778170bdfe5fd425879735b43106e/ansible-2.4.0.0.tar.gz"
    sha256 "1a276fee7f72d4e6601a7994879e8467edb763dacc3e215258cfe71350b77c76"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/58/e9/6d7f1d883d8c5876470b5d187d72c04f2a9954d61e71e7eb5d2ea2a50442/bcrypt-3.1.3.tar.gz"
    sha256 "6645c8d0ad845308de3eb9be98b6fd22a46ec5412bfc664a423e411cdd8f5488"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/4e/32/4070bdf32812c89eb635c80880a5caa2e0189aa7999994c265577e5154f3/cffi-1.11.0.tar.gz"
    sha256 "5f4ff33371c6969b39b293d9771ee91e81d26f9129be093ca1b7be357fcefd15"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9c/1a/0fc8cffb04582f9ffca61b15b0681cf2e8588438e55f61403eb9880bd8e0/cryptography-2.0.3.tar.gz"
    sha256 "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/90/61/f820ff0076a2599dd39406dcb858ecb239438c02ce706c8e91131ab9c7f1/Jinja2-2.9.6.tar.gz"
    sha256 "ddaa01a212cd6d641401cb01b605f4a4d9f37bfc93043d7f760ec70fb99ff9ff"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/83/78/4569a543ef2cb304e9b82387f555021c13a845d0ad1e2bb59272ade67669/paramiko-2.3.1.tar.gz"
    sha256 "fa6b4f5c9d88f27c60fd9578146ff24e99d4b9f63391ff1343305bfd766c4660"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/95/08/80895c3bffb2da55c9de25e8292cfffb4768058eae4465a8bd1459d1cd6b/pyasn1-0.3.6.tar.gz"
    sha256 "f0380ea97db0ede095a0dd87ce3003d46c197191f924206e43f776fc77e51f09"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/8d/f3/02605b056e465bf162508c4d1635a2bccd9abd1ee3ed2a1bb4e9676eac33/PyNaCl-1.1.2.tar.gz"
    sha256 "32f52b754abf07c319c04ce16905109cab44b0e7f7c79497431d3b2000f8af8c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<-EOF.undent
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOF
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
