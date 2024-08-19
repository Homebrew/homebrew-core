class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/46/2f/d030d0d3a50b776f910dd87dc1d57dd4a27bfad176b85882f463632e4747/pip_audit-2.7.3.tar.gz"
  sha256 "08891bbf179bffe478521f150818112bae998424f58bf9285c0078965aef38bc"
  license "Apache-2.0"
  revision 2
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd2e4b45cc428baf76ec5bc9dca376f78ef125d39dc7b6208e15b3176aabd38a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b61674a93ad4058f52a641cd6edaaf6454396e7df51992d649630d2d10b8a09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39ec24e7413a26c6d5cf38c26bd6e5aad16b34a0c8d1817733275926cb6cc005"
    sha256 cellar: :any_skip_relocation, sonoma:         "fce6ba3bdb74f0fa3cfa7ae47bead49043d801608e29ee5b8349f3f538e4bcef"
    sha256 cellar: :any_skip_relocation, ventura:        "1a672dcc6e3e689cce4aca54794fe9a5cbe1ced2b3a003e97aeb99f341114eb7"
    sha256 cellar: :any_skip_relocation, monterey:       "81ee8af8b3b14735a19bfa1ceaf7e87a25dffb65e049afea74999910464f5d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172fe585ae0c921836c3f919df0ea8336b3df10330a44caaf0808517121cf629"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/a2/d9/b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9/boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/06/55/edea9d90ee57ca54d34707607d15c20f72576b96cb9f3e7fc266cb06b426/cachecontrol-0.14.0.tar.gz"
    sha256 "7db1195b41c81f8274a7bbd97c956f44e8348265a1bc7641c37dfebc39f0c938"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/34/59/a105792e05c13fec17e067f6f2fd3debecd213e5b3dd4500545a719e273d/cyclonedx_python_lib-7.4.1.tar.gz"
    sha256 "23bf8196e008bb8e06c1040ad2ab69492891d8a581cb2aefa36a77f199790a37"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/69/7d/73d36db6955bde2ed495ce40ce02c9a2533b8c7b64fd42a38b1ee879ea18/filelock-3.15.1.tar.gz"
    sha256 "58a2549afdf9e02e10720eaa4d4470f56386d7a6f72edd7d0596337af8ed7ad8"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/04/75/d0b021ce2ab2eb9f28151dbae650e5ec4bca23f375b973c3807f3009c56f/license-expression-30.3.0.tar.gz"
    sha256 "1295406f736b4f395ff069aec1cebfad53c0fcb3cf57df0f5ec58fc7b905aea5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/56/1b/cdd6305870afd6f2333a4d9fddc9321058a8da8f512639ca8f3cc3559084/packageurl_python-0.15.1.tar.gz"
    sha256 "9a37b9a7cad9a2872b4612151ba3749fd9dec90485577c14d374b6e66b7edf03"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/ae/28/da6bd24c67a6d52a535fa8b888b1495d1d2ec7b2705a45ce5d351a3047bb/pip-api-0.0.33.tar.gz"
    sha256 "1c2522ae21efcb034d89cc99f6cf1025293b31c63c29ee98b23f03a85f36bdae"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/17/86/70bfc6531c028c81b60b37aa5fb67e35c733bed4b3fc851fbb52e2ae0bbc/py_serializable-1.0.3.tar.gz"
    sha256 "da3cb4b1f3cc5cc5ebecdd3dadbabd5f65d764357366fa64ee9cbaf0d4b70dcf"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"requirements.txt"
    test_file.write <<~EOS
      six==1.16.0
    EOS
    output = shell_output("#{bin}/pip-audit --requirement #{test_file} --no-deps --progress-spinner=off 2>&1")
    assert_match "No known vulnerabilities found", output
  end
end
