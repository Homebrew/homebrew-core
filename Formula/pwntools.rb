class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.1.1.tar.gz"
  sha256 "b484b5d5a95b52f9a946ddaa5e093be55166dbbd572634640875b2a8e2d51830"

  bottle do
    sha256 "060d65a76baaa2829f7002745e59d4c97fa4a2cad6b35d1f870800ab8e45344f" => :sierra
    sha256 "5ebe620341c89a7bf1828ed06f8652f70b83ec4b24ae06b69affbf5b1f9e4298" => :el_capitan
    sha256 "50b504d24fc04824b8504fdc222a73711cbd217b384f7a809d7bf0d002f19bb2" => :yosemite
  end

  depends_on :python
  depends_on "openssl"
  depends_on "binutils" => :recommended

  conflicts_with "moreutils", :because => "Both install `errno` binaries"

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/e7/29/e9ad2a12c38f19e9ca8aff05122e5b9e271da6ecbfb6c4e20aee381b49ff/capstone-3.0.4.tar.gz"
    sha256 "945d3b8c3646a1c3914824c416439e2cf2df8969dd722c8979cdcc23b40ad225"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/03/1a/60984cb85cc38c4ebdfca27b32a6df6f1914959d8790f5a349608c78be61/cryptography-1.5.2.tar.gz"
    sha256 "eb8875736734e8e870b09be43b17f40472dc189b1c422a952fa8580768204832"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/7a/ae/925434246ee90b42e8ef57d3b30a0ab7caf9a2de3e449b876c56dcb48155/Mako-1.0.4.tar.gz"
    sha256 "fed99dbe4d0ddb27a33ee4910d8708aca9ef1fe854e668387a9ab9a90cbf9059"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/28/ad/4e6601d14b11bb300719a8bb6247f6ef5861467a692523c978a4e9e3981a/packaging-16.7.tar.gz"
    sha256 "2e246cde53917a320c4edb549b6b6ed0c80e22be835047bad814687c7345011e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/38/e2/b23434f4030bbb1af3bcdbb2ecff6b11cf2e467622446ce66a08e99f2ea9/pluggy-0.4.0.zip"
    sha256 "dd841b5d290b252cf645f75f3bd37ceecfa0f36394ab313e4f785fe68a4081a4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/6c/49/0f784a247868e167389f6ac76b8699b2f3d6f4e8e85685dfec43e58d1ed1/psutil-4.4.2.tar.gz"
    sha256 "1c37e6428f7fe3aeea607f9249986d9bb933bb98133c7919837fd9aac4996b07"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/f4/9a/8dfda23f36600dd701c6722316ba8a3ab4b990261f83e7d3ffc6dfedf7ef/py-1.4.31.tar.gz"
    sha256 "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/eb/83/00c55ff5cb773a78e9e47476ac1a0cd2f0fb71b34cb6e178572eaec22984/pycparser-2.16.tar.gz"
    sha256 "108f9ff23869ae2f8b38e481e7b4b4d4de1e32be968f29bbe303d629c34a6260"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/ba/78/d4a186a2e38731286c99dc3e3ca8123b6f55cf2e28608e8daf2d84b65494/pyelftools-0.24.tar.gz"
    sha256 "e9dd97d685a5b96b88a988dabadb88e5a539b64cd7d7927fac9a7368dc4c459c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/e2/aa/156253072c8fe2b4d90da455a964ed82504d11b6f816536ad11de8406fa9/pypandoc-1.2.0.zip"
    sha256 "752a79884cc7be4df028d805a087a8af84c333fed5c7eeedf01e28e06f7eb5eb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1f/3b/ee6f354bcb1e28a7cd735be98f39ecf80554948284b41e9f7965951befa6/pyserial-3.2.1.tar.gz"
    sha256 "1eecfe4022240f2eab5af8d414f0504e072ee68377ba63d3b6fe6e66c26f66d1"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/16/56/9b3513078f837fa8cb88ee01ec1cd805ed8104a37bc02ca8c2588ae8fe5a/PySocks-1.5.7.tar.gz"
    sha256 "e51c7694b10288e6fd9a28e15c0bcce9aca0327e7b32ebcd9af05fcd56f38b88"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "ROPGadget" do
    url "https://files.pythonhosted.org/packages/c5/d5/03e3afe251a7aed91254a0ccef7bdb59923e29016ac41ac8a5d57f3461d6/ROPGadget-5.4.tar.gz"
    sha256 "af37e327908796894928f0b3831008c7747d189812d37b4362e3e03a3af194a7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tox" do
    url "https://files.pythonhosted.org/packages/37/7b/e86e836bb243a2cb5af0988f1fb4195d3447033e7cec0af2955d590b7b16/tox-2.4.1.tar.gz"
    sha256 "6673571a3c4b1561b564e2b1cce55bddfb4f3efdb387ba4eb0a3688bbe2496db"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/8b/2c/c0d3e47709d0458816167002e1aa3d64d03bdeb2a9d57c5bd18448fd24cd/virtualenv-15.0.3.tar.gz"
    sha256 "6d9c760d3fc5fa0894b0f99b9de82a4647e1164f0b700a7f99055034bf548b1d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
