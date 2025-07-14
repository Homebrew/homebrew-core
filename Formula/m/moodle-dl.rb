class MoodleDl < Formula
  include Language::Python::Virtualenv

  desc "Downloads course content fast from Moodle (e.g., lecture PDFs)"
  homepage "https://github.com/C0D3D3V/Moodle-DL"
  url "https://files.pythonhosted.org/packages/0b/44/9c283a04b0ede0bcaa2f3595b523cb115c662fe349f215631484035126d1/moodle_dl-2.3.13.tar.gz"
  sha256 "7a6d813b3241497fb79a34a428aa266b2d2d3c175e05d46752e0a8040adaddce"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a33501c8ec3018bff121de1a72eda529db07a14f5cca76aa397e9f654a8c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2fe23fdefa04d387630b68a09c0f7cc8f38ceafff6d31ed3ba63e764d5019bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "077b3ab51216e4c96bd3fe6dae6212a3fa37a9ba0f51efee46da390eb55ffd53"
    sha256 cellar: :any_skip_relocation, sonoma:        "d24a3816f81019adc49b42e831761437afe561561ef4aad13fefdd174cfe0299"
    sha256 cellar: :any_skip_relocation, ventura:       "6fd295282ad3715bc5d89b18edd9ef90739e0a410efc9a7c981d6c1e1f38eaef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82acb8ced94cde6c2eb467fff3a374d3bfbb07a938fa4e3ab086c088b5c0ab02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0985d14ae5460dbb2eae0cbe7787b08554feecc5139c27ff3cf5fac8b801bd9"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.13"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/17/0a/163e5260cecc12de6abc259d158d9da3b8ec062ab863107dcdb1166cdcef/aiodns-3.5.0.tar.gz"
    sha256 "11264edbab51896ecf546c18eb0dd56dff0428c6aa6d2cd87e643e07300eb310"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/42/6e/ab88e7cb2a4058bed2f7870276454f85a7c56cd6da79349eb314fc7bbcaa/aiohttp-3.12.13.tar.gz"
    sha256 "47e2da578528264a12e4e3dd8dd72a7289e5f812758fe086473fab037a10fcce"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/79/b1/b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6/frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/3d/2c/5dad12e82fbdf7470f29bff2171484bf07cb3b16ada60a6589af8f376440/multidict-6.6.3.tar.gz"
    sha256 "798a9eb12dab0a6c2e29c1de6f3468af5cb2da6053a20dfa3344907eed0937cc"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a6/16/43264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776/propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/f5/37/4d4f8ac929e98aad64781f37d9429e82ba65372fc89da0473cdbecdbbb03/pycares-4.9.0.tar.gz"
    sha256 "8ee484ddb23dbec4d88d14ed5b6d592c1960d2e93c385d5e52b6fad564d82395"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/dd/f8/8657b8cbb4ebeabfbdf991ac40eca8a1d1bd012011bd44ad1ed10f5cb494/readchar-4.2.1.tar.gz"
    sha256 "91ce3faf07688de14d800592951e5575e9c7a3213738ed01d394dcc949b79adb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/10/59/eb90c45cb836cf8bec973bba10230ddad1c55e2b2e9ffa9d7d7368948358/sentry_sdk-2.32.0.tar.gz"
    sha256 "9016c75d9316b0f6921ac14c8cd4fb938f26002430ac5be9945ab280f78bec6b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "xmpppy" do
    url "https://files.pythonhosted.org/packages/b9/dc/c82cf11d776b371863bef8de412e949467e291977d2aaded91d010713a6f/xmpppy-0.7.1.tar.gz"
    sha256 "c5ff61c0fa0ad8b9e521939f944bbcdac0a2375e7ec24201605cc540857e0400"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/3c/fb/efaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963/yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/23/9c/ff64c2fed7909f43a9a0aedb7395c65404e71c2439198764685a6e3b3059/yt_dlp-2025.6.30.tar.gz"
    sha256 "6d0ae855c0a55bfcc28dffba804ec8525b9b955d34a41191a1561a4cec03d8bd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moodle-dl --version")

    (testpath/"config.json").write <<~JSON
      {
        "token": "invalidtoken",
        "privatetoken": "invalidprivatetoken",
        "moodle_domain": "localhost",
        "moodle_path": "/moodle/"
      }
    JSON

    assert_match "Connection error", shell_output("#{bin}/moodle-dl 2>&1", 1)
    assert_path_exists testpath/"moodle_state.db"
  end
end
