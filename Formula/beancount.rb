class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "http://furius.ca/beancount/"
  url "https://files.pythonhosted.org/packages/34/16/41f47df1a7929addab1c75a0f8905890827f00694d4de9d10c83bd5799ff/beancount-2.3.2.tar.gz"
  sha256 "0d6205a0882c3f9bc3ebfd642b329659412e10b36a3e0c7e2648410d9670d7f1"
  license "GPL-2.0"
  revision 1
  head "https://github.com/beancount/beancount.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ae26e4efac2cb7cd50c9c88de5ea6e30f05ee54f452bf6156b2e2a33ebc77857" => :catalina
    sha256 "ccfc81e943ac128a947593513c078614198b6843149756f1b5be378def0ebace" => :mojave
    sha256 "dedb54aead11e33a9a29ef57273f1fa3042e52fd2cb27990afcaee2363c6da7d" => :high_sierra
  end

  depends_on "python@3.9"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/81/d0/641b698d05f0eaea4df4f9cebaff573d7a5276228ef6b7541240fe02f3ad/attrs-20.2.0.tar.gz"
    sha256 "26b54ddbbb9ee1d34d5d3668dd37d6cf74990ab23c828c2888dccdceee395594"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c6/62/8a2bef01214eeaa5a4489eca7104e152968729512ee33cb5fbbc37a896b7/beautifulsoup4-4.9.1.tar.gz"
    sha256 "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/d9/4f/57887a07944140dae0d039d8bc270c249fc7fc4a00744effd73ae2cde0a9/bottle-0.12.18.tar.gz"
    sha256 "0819b74b145a7def225c0e83b16a4d5711fde751cd92bae467a69efce720f69e"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fc/c8/0b52cf3132b4b85c9e83faa3e4d375575afeb3a1710c40b2b2cd2a3e5635/cachetools-4.1.1.tar.gz"
    sha256 "bbaa39c3dede00175df2dc2b03d0cf18dd2d32a7de7beb68072d13043c9edb20"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/6b/0b/992fd8a7fcc8b6498b85ec771237a7306e84f3523d9f34c9ea47ca00d82a/google-api-core-1.22.2.tar.gz"
    sha256 "779107f17e0fef8169c5239d56a8fbff03f9f72a3893c0c9e5842ec29dfedd54"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/cc/8f/a3fcab381fa32719698d022cbb527de3b56bfaf64b75cf31fa4524ec5ee1/google-api-python-client-1.12.1.tar.gz"
    sha256 "ddadc243ce627512c2a27e11d369f5ddf658ef80dbffb247787499486ef1ea98"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/23/70/1fa426fc0d01afe03dc50a8c1f5732dc224a32f9d16420876c0e7b32462c/google-auth-1.21.1.tar.gz"
    sha256 "bcbd9f970e7144fe933908aa286d7a12c44b7deb6d78a76871f0377a29d09789"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/6c/5e/97a5e7573457020351a275c74c559dbe2ebe1c606119f991541c98ffa651/google-auth-httplib2-0.0.4.tar.gz"
    sha256 "8d092cc60fb16517b12057ec0bba9185a96e3b7169d86ae12eae98e645b7bc39"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/3f/a1282d82def57e0c28bab597d25785774a4e64433aac9cc136e65c500da8/googleapis-common-protos-1.52.0.tar.gz"
    sha256 "560716c807117394da12cecb0a54da5a451b5cf9866f1d37e9a5e2329a665351"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/98/3f/0769a851fbb0ecc458260055da67d550d3015ebe6b8b861c79ad00147bb9/httplib2-0.18.1.tar.gz"
    sha256 "8af66c1c52c7ffe1aa5dc4bcd7c769885254b0756e6e69f953c7f0ab49a70ba3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/aa/6e/60dafce419de21f2f3f29319114808cac9f49b6c15117a419737a4ce3813/iniconfig-1.0.1.tar.gz"
    sha256 "e5f92f89355a67de0595932a6c6c02ab4afddc6fcdc0bfc5becd0d60884d3f69"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2c/4d/3ec1ea8512a7fbf57f02dee3035e2cce2d63d0e9c0ab8e4e376e01452597/lxml-4.5.2.tar.gz"
    sha256 "cdc13a1682b2a6241080745b1953719e7fe0850b40a5c71ca574f090a1391df6"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/d6/03/37d7c431c4c1c17507fb7b89240ddb7be70f2027277960d525f1679363c1/more-itertools-8.5.0.tar.gz"
    sha256 "6f83822ae94818eae2612063a5101a7311e68ae8002005b5e05f03fd74a86a20"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/25/ef/8f36bc7e4c3dcad241a9e7a51520d30712a7abc034343bed841ff4ea3289/protobuf-3.13.0.tar.gz"
    sha256 "6a82e0c8bb2bf58f606040cc5814e07715b2094caeba281e2e7d0b0e2e397db5"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/97/a6/ab9183fe08f69a53d06ac0ee8432bc0ffbb3989c575cc69b73a0229a9a99/py-1.9.0.tar.gz"
    sha256 "9ca6883ce56b4e8da7e79ac18787889fa5206c79dcc67fb065376cd2fe03f342"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/7b/ed/456fa3994bca2b104f83538a9eff606fa2b3856767af019d0906eb4fd141/pytest-6.0.2.tar.gz"
    sha256 "c8f57c2a30983f469bf03e68cdfa74dc474ce56b8f280ddcb080dfd91df01043"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/e3/85/1aff76b966622868a73717abd8b501a3c91890e23a65e5f574ff6df1970f/python-magic-0.4.18.tar.gz"
    sha256 "b757db2a5289ea3f1ced9e60f072965243ea43a2221430048fd8cacab17be0ce"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/a2/d5/04b8a9719149583fec76efdff2e7a81c6e3cc34909ee818d3fbf115edc2e/rsa-4.6.tar.gz"
    sha256 "109ea5a66744dd859bf16fe904b8d8b627adafb9408753161e766a92e7d681fa"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3e/db/5ba900920642414333bdc3cb397075381d63eafc7e75c2373bbc560a9fa1/soupsieve-2.0.1.tar.gz"
    sha256 "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz"
    sha256 "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_equal "", shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
