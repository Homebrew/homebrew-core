class Lexicon < Formula
  include Language::Python::Virtualenv

  desc "Manipulate DNS records on various DNS providers in a standardized way"
  homepage "https://github.com/dns-lexicon/dns-lexicon"
  url "https://files.pythonhosted.org/packages/4b/37/291063606930c749681b2ad0612952b1bc5374ab2037346566812ba8f2c9/dns_lexicon-3.25.2.tar.gz"
  sha256 "a377bf2b4017ee46de8d5515cf2c204bfda74b49032dc5420bd3100993f28deb"
  license "MIT"
  revision 3
  head "https://github.com/dns-lexicon/dns-lexicon.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "71fdc22b2303fca1d4b1558c283691863e272044cbf414b897f6c1af4c7efb45"
    sha256 cellar: :any, arm64_tahoe:       "43e9569347536382b333612ee48239ba9ae7aa02b37ecdc7a997561b9c5ef9e6"
    sha256 cellar: :any, arm64_sequoia:     "497b31006ec3808025ff8db5744908d8e979381a06ed75959d94e86c4badb6a7"
    sha256 cellar: :any, arm64_linux:       "0e3dbad1fe7e082c2fe45c3807170730c9b85c26b88723ef591148ffc07189b9"
    sha256 cellar: :any, x86_64_linux:      "3b69695e9f82495e01b9f0d83f06e6a678279dfde01fc9309f3811f0d8e61b4c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:     "dns-lexicon[full]",
                exclude_packages: %w[certifi cryptography]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/16/b6/41173fa75983750c794e9b64017a3203407725a0e8c9c7f6de39686dc97b/boto3-1.43.96.tar.gz"
    sha256 "30fb2b5467ef5175ed48f43c06c435eec5da841594a5d7653c4da679df0740fc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d2/8d/a3d51a726b62585d032bc55eaa45068dec381d51329cca0140f9c233b792/botocore-1.43.96.tar.gz"
    sha256 "3ef7c8c40738bb42a40eb0ac3dc2d9f1698946541874ae9b505e49f289272805"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5e/ac/8c98b17ee3900147b38ef7884a1e590b070b63f0d59fd8b46ef0205f4576/filelock-4.0.0.tar.gz"
    sha256 "3611eca5d818ca9b00ec3cc7db1dcfe1e2aafc8d44fb4920d8cf60ad1f6bfda6"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "localzone" do
    url "https://files.pythonhosted.org/packages/f9/1a/2406e73b9dedafc761526687a60a09aaa8b0b2f2268aa084c56cbed81959/localzone-0.9.8.tar.gz"
    sha256 "23cb6b55a620868700b3f44e93d7402518e08eb7960935b3352ad3905c964597"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/14/95/989c1b5ca17b72128661530cd6e351a0a83cda9a4d6c036e9ed976c18931/multidict-6.8.0.tar.gz"
    sha256 "5cd4637ce76312ba1e05eb9c5193fec231f64fee0944e135fa1e951242355b37"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/12/36/d97822d2cfc4dd842934724a45d4e4591433432d673ebf5bb7c342249508/oci-2.186.0.tar.gz"
    sha256 "d8c75fb73bddaadcf3835b07b584f80c785686aa3c8a66ae4e4062ac63757c58"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/b9/8adc4e1b422b27fd88540ec7bf1f406f77ef393ec070e26fc430e914cde8/platformdirs-4.11.9.tar.gz"
    sha256 "e2c66a8d384596cd98e3c4aea2d761df7bac95d9d8a2cc3946daa8cdafdaebc1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/af/c3/8a3b59c25070cc61dc517fbdfa5dc0904670c96f605cc69759dc09166b99/pyjwt-2.14.0.tar.gz"
    sha256 "77283c83fb56ecf566a886c757a714bc83668e38156de2cce8263302f42e0b86"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyotp" do
    url "https://files.pythonhosted.org/packages/2d/c6/c5d96a86fd0bf6fa1bbb5c5c341ff3208638b692727a683c8289068d9a11/pyotp-2.10.0.tar.gz"
    sha256 "d01e9703443616b03c57c700b5cbffd56a1f929c1b0f8f03131bc78c1fca9d3f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/22/80/44636b363e75af7f5e6ac0571137466fec66e47016179139d0019a453ab7/requests_unixsocket-0.4.1.tar.gz"
    sha256 "b2596158c356ecee68d27ba469a52211230ac6fb0cde8b66afb19f0ed47a1995"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "softlayer" do
    url "https://files.pythonhosted.org/packages/1e/88/83d1cb5768d1bb72b19664b99c025c7acd8a035504c2a1328af850db6a16/softlayer-6.2.9.tar.gz"
    sha256 "e47537caa1e2b40062500c95b906e079a9f490bb3b5bfc841501eea4fa5a7148"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
  end

  resource "tencentcloud-sdk-python" do
    url "https://files.pythonhosted.org/packages/12/7f/cf277dcc5ce9985741282d045b32ec5b2c70fee9038ce3c767e5b4a6b6a1/tencentcloud_sdk_python-3.1.176.tar.gz"
    sha256 "48421ac14ae1ace37301c91de46d70e3d4afba4674ffe6efb3b08c77caee4468"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/01/a9/ed5d3be29bfaf90c00b7159d3884b311f3880b55833d1c7be764164dc288/tldextract-5.3.2.tar.gz"
    sha256 "c017431bc0800f2d3d1b57cce36e06668f0930f60a6d8c4615d4e2b8da298fa9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/36/57/ed58088fafdf4c55a0ad6bde846502567645424d7ebf325230b9237f4085/wcwidth-0.8.3.tar.gz"
    sha256 "d128512515fbf4612e0ff21fd6380399210318b7b54a9af59dff8454cf9730eb"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zeep" do
    url "https://files.pythonhosted.org/packages/7e/c2/e06e5f177d818d0fc34fcbe2f98c175af2cba63b7d90f4bfcb6fe360d343/zeep-4.3.3.tar.gz"
    sha256 "99d5059f92f721020998695fd9c85289ccb03ec5a2398ad49c6dbe43f19cfb94"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/lexicon route53 list brew.sh TXT 2>&1", 1)
    assert_match "Unable to locate credentials", output

    output = shell_output("#{bin}/lexicon cloudflare create example.com TXT --name foo --content bar 2>&1", 1)
    assert_match "400 Client Error: Bad Request for url", output

    assert_match "lexicon #{version}", shell_output("#{bin}/lexicon --version")
  end
end
