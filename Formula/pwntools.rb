class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.1.1.tar.gz"
  sha256 "b484b5d5a95b52f9a946ddaa5e093be55166dbbd572634640875b2a8e2d51830"
  revision 1

  bottle do
    sha256 "eb7ef53fe7a303f9315ad92690bd4a6989ce76de17d6d5a3163e24d9b7ad8f63" => :sierra
    sha256 "30296daed88d76dcefc897105f0925df46a02a9ba22138bafc3f6b29b3349cf0" => :el_capitan
    sha256 "5bc0f2d492c2dd408506277386841c5dad16569460c594c88c799d3659508e08" => :yosemite
  end

  depends_on :python
  depends_on "openssl@1.1"
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
    url "https://files.pythonhosted.org/packages/6c/c5/7fc1f8384443abd2d71631ead026eb59863a58cad0149b94b89f08c8002f/cryptography-1.5.3.tar.gz"
    sha256 "cf82ddac919b587f5e44247579b433224cc2e03332d2ea4d89aa70d7e6b64ae5"
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
    url "https://files.pythonhosted.org/packages/20/ce/296b1037ed9b7803ed4e738b83ae244d2834e97e4ea24d52a6d46c12a884/Mako-1.0.5.tar.gz"
    sha256 "e3e27cdd7abfd78337f33bd455f756c823c2d6224ad440a88f14bbd53a5ebc93"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
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
    url "https://files.pythonhosted.org/packages/93/7f/347309562d30c688299727e65f4d76ef34180c406dfb6f2c7b6c8d746e13/psutil-5.0.0.zip"
    sha256 "5411e22c63168220f4b8cc42fd05ea96f5b5e65e08b93b675ca50653aea482f8"
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
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/ba/78/d4a186a2e38731286c99dc3e3ca8123b6f55cf2e28608e8daf2d84b65494/pyelftools-0.24.tar.gz"
    sha256 "e9dd97d685a5b96b88a988dabadb88e5a539b64cd7d7927fac9a7368dc4c459c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/68/6d/4f8ff7661e13f5038bafe1e7d8c4c2a0fb83f3fbe590de16da9405af0dc7/pypandoc-1.3.3.tar.gz"
    sha256 "a6fea20b895bfa3f5b32bec541fde3708843ff73a10877a1ad113f62a7704818"
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

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a7/37/947b4329c4a3c72093b6c8e9b4be8c7f10c32dbb78848d3a234ce01c059d/wheel-0.30.0a0.tar.gz"
    sha256 "98f3e09b4ad7f5649a7e3d00e0e005ec1824ddcd6ec16c5086c05b1d91ada6da"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
