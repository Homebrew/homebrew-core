class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  # checkov should only be updated every 15 releases on multiples of 15
  url "https://files.pythonhosted.org/packages/d0/71/058b52c0824bceb3693145d81c216b5867e9f19d9dcccfc59a88f0ab3cf0/checkov-2.0.1200.tar.gz"
  sha256 "51f236b54213915b0737a370184bba667b3a5d22af93c4c005b224d2464ecd75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdfe155e793228b15690524fee36f6f058212480701531eba321d77aa4d71e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a29a43e622aaed6d02c5f88cab286b9ca118bcb7f3b4844ecde759ce548b11"
    sha256 cellar: :any_skip_relocation, monterey:       "e36c65629bcb9313ab293f25f689f449b9a4afa2d69929e08990bd1bfc619aba"
    sha256 cellar: :any_skip_relocation, big_sur:        "01730e736dea34909ab567628437098b6385d9c20e9a516783b1a977ee42c7b3"
    sha256 cellar: :any_skip_relocation, catalina:       "91c26b3e6a486e6515ba9cb918279871c425a91df03c0b87952309a228fd67cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe065a440865f15022ade9c44905f3d9a10fa8819dfe2709cb9e6dbe52ea0b2"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/27/79/df72e25df0fdd9bf5a5ab068539731d27c5f2ae5654621ae0c92ceca94cf/aiodns-3.0.0.tar.gz"
    sha256 "946bdfabe743fceeeb093c8a010f5d1645f708a241be849e17edfb0e49e08cd6"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/59/30/64e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1/aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "bc-python-hcl2" do
    url "https://files.pythonhosted.org/packages/5a/75/88e3b41c1b6ac30d5e04be4d18304b574b121e1bdc4a0b0f3d49bda55136/bc-python-hcl2-0.3.42.tar.gz"
    sha256 "b383b6c6835a7d81c5053a3190ace0279363407e0ce43ecf729b2688066a47ff"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c3/eb/8585cdeff525464157e44df5e5dd41fabf4c0f8451b3702698860ae5233d/boto3-1.24.4.tar.gz"
    sha256 "8bfb695cbe27d2ee9730ea4e1c894ef1fc255219d3fc7bc804171943ae8d7914"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b4/77/3e189fcd0e7425bd24743a608673373521726436c6bccffa12bfb373988a/botocore-1.27.4.tar.gz"
    sha256 "866ac4ad7de326cfb6956462cc224eee1ef1c17987c2313c6fecdbe017e753fc"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/3c/86/5de6d909d9dcc85627a178788ec3e8c3ef81cda175badb48ad0bb582628d/click-option-group-0.5.3.tar.gz"
    sha256 "a6e924f3c46b657feb5b72679f7e930f8e5b224b766ab35c91ae4019b4e0615e"
  end

  resource "cloudsplaining" do
    url "https://files.pythonhosted.org/packages/d1/b0/0ec965daffb16dfdcae8d2a81be5474f21be37fd007cc1d0bf84f038a674/cloudsplaining-0.5.0.tar.gz"
    sha256 "59b9fb7dfd023297153adc13cce6695413019e13488d69f78bbde97682125489"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/d6/99/cb03356e010d98c1e52465f9726dea0c77e95180f8b3f3dd3c412141423b/cyclonedx-python-lib-2.4.0.tar.gz"
    sha256 "35ef1dbff4aab8ef143552cecde4ef9050f805957519339991e488f80cab36e2"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deep_merge" do
    url "https://files.pythonhosted.org/packages/a5/25/aa35c20acd8a4f515f9e4c8dee4c7731446234101a6dae0c34cf498bb342/deep_merge-0.0.4.tar.gz"
    sha256 "b54415f90934c42e334114e2864cb4d4e7335b34ad396e35ad8610c96065a47e"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/cd/b6/08bc0bf3cf2cf0d7b08442d4d2bcf2d94144db7e22f0d4aa5621789c0e15/detect_secrets-1.2.0.tar.gz"
    sha256 "c160e897b3d0e81bf9cf0f6cc2e5e6434fa609a159f9a2849fcae0a08b4e2a30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/ab/d2/45ea0ee13c6cffac96c32ac36db0299932447a736660537ec31ec3a6d877/docker-5.0.3.tar.gz"
    sha256 "d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb"
  end

  resource "dockerfile-parse" do
    url "https://files.pythonhosted.org/packages/d0/f6/8eb044e3837f6da0a85d9f73158104fecdab68bc86a83625b1e398963ed3/dockerfile-parse-1.2.0.tar.gz"
    sha256 "07e65eec313978e877da819855870b3ae47f3fac94a40a965b9ede10484dacc5"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/88/b2/abc5803f37a2ea1045d68765acfcb4ec166bc9e08c3ba451c53af29a73f2/dpath-1.5.0.tar.gz"
    sha256 "496615b4ea84236d18e0d286122de74869a60e0f87e2c7ec6787ff286c48361b"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/f4/f7/8dfeb76d2a52bcea2b0718427af954ffec98be1d34cd8f282034b3e36829/frozenlist-1.3.0.tar.gz"
    sha256 "ce6f2ba0edb7b0c1d8976565298ad2deba6f8064d2bebb6ffce2ca896eb35b0b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/06/7e/44686b986ef9ca6069db224651baaa8300b93af2a085a5b135997bf659b3/jmespath-1.0.0.tar.gz"
    sha256 "a490e280edd1f57d6de88636992d05b71e97d69a26a19f058ecf7d304474bf5e"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/cd/c2/5cd85d8a7de7818892fd8f751d30b6d050a8471c6647d2fda47cc542f9b4/jsonpath-ng-1.5.3.tar.gz"
    sha256 "a273b182a82c1256daab86a313b937059261b5c5f8c4fa3fc38b882b344dd567"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "junit-xml-2" do
    url "https://files.pythonhosted.org/packages/4d/f2/a99adf9deb57949b81ff8e113edf971da1840251794a6f4184d61faa5a65/junit-xml-2-1.9.tar.gz"
    sha256 "3b8d9635c5215f754c7807104f6493e3ea3bc9481e2d33db294560da3a1b00f7"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/a3/c5/11d0a086590b207ad1b6c9ba6e019f8290652f3d703cdb002d72e220dd99/lark-1.1.2.tar.gz"
    sha256 "7a8d0c07d663da9391d7faee1bf1d7df4998c47ca43a593cbef5c7566acd057a"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d6/58/79df20de6e67a83f0d0bbfe6c19bb82adf68cdf362885257eb01099f930a/Markdown-3.3.7.tar.gz"
    sha256 "cbb516f16218e643d8e0a95b309f77eb118cb138d39a4f27851e6a63581db874"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/78/6c/85c0664365d32a32806bd12d46ea5dc466aa3aa7e8086e5daf3505b8cf33/networkx-2.8.3.tar.gz"
    sha256 "67fab04a955a73eb660fe7bf281b6fa71a003bc6e23a92d2f6227654c5223dbe"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/6e/ee/8d89d660da6e44d77f547de9949b380dc93b08b758ee361bc237bcc8b179/packageurl-python-0.9.9.tar.gz"
    sha256 "872a0434b9a448b3fa97571711f69dd2a3fb72345ad66c90b17d827afea82f09"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/69/08/19f2f761da39b93ab6bb736cc6c05cce64448afac0d14c5d6391e6022769/policy_sentry-0.12.3.tar.gz"
    sha256 "75137fc7e1311bc24836855dce7caa40548f3f81a72045bb6731d55f48de644a"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/c7/98/1cfb0d26a098ae695c6b004785008ff4d072dd75e1af5f37ed2ae485bd65/policyuniverse-1.5.0.20220523.tar.gz"
    sha256 "826705f0a77018b314e60d4d620c4b2a004b935c89ad68bf7695444c3698d15a"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/10/88/ef38a6e4bc375600d3031e405a8d3b3dc4a154fccffd21d5d06e66c96230/prettytable-3.3.0.tar.gz"
    sha256 "118eb54fd2794049b810893653b20952349df6d3bc1764e7facd8a18064fa9b0"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/83/61/17bd0cfb9c4dc8c3738484d604b50d47c78fe4fcfe0ca2c58a61a106f578/pycares-4.1.2.tar.gz"
    sha256 "03490be0e7b51a0c8073f877bec347eff31003f64f57d9518d419d9369452837"
  end

  resource "pycep-parser" do
    url "https://files.pythonhosted.org/packages/a2/3b/1cb178506df9198403d65e006c04867bfd03099f3f6d2f6b60d238d79e19/pycep-parser-0.3.6.tar.gz"
    sha256 "6518d9b90c31db4466d52570491b13231f093c975d49daa1a3570e80093fd997"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/1a/6b/9b6b8284e88105acbcb39e71bd3bfcaffcd36c2601152ae23b00e6e04d91/regex-2022.6.2.tar.gz"
    sha256 "f7b43acb2c46fb2cd506965b2d9cf4c5e64c9c612bac26c1187933c7296bf08c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/ba/97/1e6f2106412d038b2ca4b18bd652a15a50096c6829345d9d0076ad9555a5/types-setuptools-57.4.17.tar.gz"
    sha256 "9d556fcaf6808a1cead4aaa41e5c07a61f0152a875811e1239738eba4e0b7b16"
  end

  resource "types-toml" do
    url "https://files.pythonhosted.org/packages/c5/da/a5fb5c4eb663a1cd2d0c8ef619c42d51e6b8f55e155341e7b39b8c6c67b4/types-toml-0.10.7.tar.gz"
    sha256 "a567fe2614b177d537ad99a661adc9bfc8c55a46f95e66370a4ed2dd171335f9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
  end

  resource "update-checker" do
    url "https://files.pythonhosted.org/packages/5c/0b/1bec4a6cc60d33ce93d11a7bcf1aeffc7ad0aa114986073411be31395c6f/update_checker-0.18.0.tar.gz"
    sha256 "6a2d45bb4ac585884a6b03f9eade9161cedd9e8111545141e9aa9058932acb13"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/7c/de/9f5354b4b37df453b7d664f587124c70a75c81805095d491d39f5b591818/websocket-client-1.3.2.tar.gz"
    sha256 "50b21db0058f7a953d67cc0445be4b948d7fc196ecbeb8083d68d94628e4abf6"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  def install
    inreplace "checkov/common/output/report.py", "from junit_xml", "from junit_xml_2"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    output = shell_output("#{bin}/checkov -f #{testpath}/test.tf 2>&1", 1)
    assert_match "Passed checks: 4, Failed checks: 6, Skipped checks: 0", output

    (testpath/"test2.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        #checkov:skip=CKV_AWS_52
        #checkov:skip=CKV_AWS_20:The bucket is a public static content host
        versioning {
          enabled = true
        }
      }
    EOS
    output = shell_output("#{bin}/checkov -f #{testpath}/test2.tf 2>&1", 1)
    assert_match "Passed checks: 4, Failed checks: 5, Skipped checks: 1", output
  end
end
