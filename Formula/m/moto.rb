class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/47/63/d944f387582cc53f53febbff2b3fa36a6d2ed7c1feef8990bf646cfa9cba/moto-5.2.2.tar.gz"
  sha256 "aac8023a429e125e91c91f8f4730a67b54f518cda587352f7e67252fe3168f75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba48bb558347b8601fbc79b17eba55fe49b2c32164451f9a692b019f8f3dff9e"
    sha256 cellar: :any, arm64_sequoia: "3a713bd442b8c7bd75245cca33f49036b0c91d5e2d59f018e725f7e9ca5a921d"
    sha256 cellar: :any, arm64_sonoma:  "862078c38513085e0e980cead5f72e4574e1d43bffbaac22f5d1ddb55690d5de"
    sha256 cellar: :any, sonoma:        "d52de2088d6d3d056fb73afc6655f80515bdacf8a4bb4986959a3e391613c781"
    sha256 cellar: :any, arm64_linux:   "816e3235fbcfbbb514f03071dbce25e6cd211797af3c5a71136931683a2a7d9e"
    sha256 cellar: :any, x86_64_linux:  "c001894f990b07ac47ea5d9fdcec9b16e5c625986d74aa6512c6c4a3c4fc46f6"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages package_name:     "moto[all,server]",
                exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/33/5f/2cdf6f7aca3b20d3f316e9f505292e1f256a32089bd702034c29ebde6242/antlr4_python3_runtime-4.13.2.tar.gz"
    sha256 "909b647e1d2fc2b70180ac586df3933e38919c85f98ccc656a96cd3f25ef3916"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/6e/2f/adeed2ce2bc62eca7ead7b3ae70fdd2cf84eecd582cd69a9529e6da89876/aws_sam_translator-1.110.0.tar.gz"
    sha256 "466ee0e8200992c51b7fd5ede5e56ca2e8dd5473cc551e8495c14f2f4d636127"
  end

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/14/25/0cbd7a440080def5e6f063720c3b190a25f8aa2938c1e34415dc18241596/aws_xray_sdk-2.15.0.tar.gz"
    sha256 "794381b96e835314345068ae1dd3b9120bd8b4e21295066c37e8814dbb341365"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f3/8f/94dfa39ec618ecb2fe5b5b79428c95100e3ae3c1aa5083c283dd3cfb5ecd/boto3-1.43.24.tar.gz"
    sha256 "ba5afa266bf7265e0c1a454fcfd48bffe5939cb16ed223bebc669c3dc8ee0bc8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/78/67/55d0611b341482bc9649d16df765f849a1862184ac3709356decf632279f/botocore-1.43.24.tar.gz"
    sha256 "0c02f2b40e99419d496ece0ea2dcdedb5c45998c16fd1674276c7dbb30767a16"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/22/7d/77cb6921776aff87b261a48610b977b1f3d790c2caee9d6d8c6d251329d1/cfn_lint-1.51.4.tar.gz"
    sha256 "d37c48645e03abecfd826b8588103b06991abd838fe05c641f2853812289c021"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/70/74/0fc0fa68d62f21daef41017dafab19ef4b36551521260987eb3a5394c7ba/flask_cors-6.0.2.tar.gz"
    sha256 "6e118f3698249ae33e429760db98ce032a8bf9913638d085ca0f4c5534ad2423"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/4d/90/f2aff026ab4aebd80eb71905106a0885f4cfde85dcf965543f45bed0d9ee/graphql_core-3.2.11.tar.gz"
    sha256 "e7e156d10beb127cab5c89ff0da71416fc73d27c484a4757d3b2d35633774802"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/d3/c3/2f590052b55cbdd0ace470ee7ee1f685f6882051be93a9374891005623e2/joserfc-1.7.0.tar.gz"
    sha256 "4aced6ab0c47846f0a531402aec2419a874b91e918df9c4c9da8a82fb559d6c4"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/32/58/250751940d75c8019659e15482d548a4aa3b6ce122c515102a4bfdac50e3/jsonpath_ng-1.8.0.tar.gz"
    sha256 "54252968134b5e549ea5b872f1df1168bd7defe1a52fed5a358c194e1943ddc3"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/39/79/cd02a4df6d9270efdc7d3feefe6edd730b0820c39eeaa107a2faee8322d5/jsonschema_path-0.5.0.tar.gz"
    sha256 "493b156ba895c97602655b620a8456caa2ce08c1aa389f5a7addec065e6e855c"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/08/a2/69df9c6ba6d316cfd81fe2381e464db3e6de5db45f8c43c6a23504abf8cb/lazy_object_proxy-1.12.0.tar.gz"
    sha256 "1f5a462d92fd0cfb82f1fab28b51bfb209fabbe6aabf7f0d51472c0c124c0c61"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/8e/d6/9c4f366d6f9bb8f8fb5eae3acac471335c39510c42b537fd515213d7d8c3/multipart-1.3.1.tar.gz"
    sha256 "211d7cfc1a7a43e75c4d24ee0e8e0f4f61d522f1a21575303ae85333dea687bf"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "openapi-schema-validator" do
    url "https://files.pythonhosted.org/packages/98/e8/ab3f27dbca54ec645f7fab714b640907d5d36c2ebb07e87eebd30bd5c81b/openapi_schema_validator-0.9.0.tar.gz"
    sha256 "b72db64315b89d21834cd3ffef37e3e6893bc876327be2d366e8424b1029afd3"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/8f/d2/640b5149cd5688bc0ad1fdbb4df6a2f7b84a093c8d787c27d566132f8b8b/openapi_spec_validator-0.9.0.tar.gz"
    sha256 "6d648cff6490ebb799dcfe273792f2941c050158854c721f086599d845da78b8"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/66/f3/5a20387de9bcd0607871bfc2198ee0e15836da7baa4592ccd7f24c27c986/pathable-0.6.0.tar.gz"
    sha256 "6404b8b82aef5ff0fd478934137128b99b12212ba35afdde5525ca4f8388ea58"
  end

  resource "py-partiql-parser" do
    url "https://files.pythonhosted.org/packages/56/7a/a0f6bda783eb4df8e3dfd55973a1ac6d368a89178c300e1b5b91cd181e5e/py_partiql_parser-0.6.3.tar.gz"
    sha256 "09cecf916ce6e3da2c050f0cb6106166de42c33d34a078ec2eb19377ea70389a"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/07/60/1d1e59c9c90d54591469ada7d268251f71c24bdb765f1a8a832cee8c6653/pydantic_settings-2.14.1.tar.gz"
    sha256 "e874d3bec7e787b0c9958277956ed9b4dd5de6a80e162188fdaff7c5e26fd5fa"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/c2/58/1fb6de3503428196df78638f991ec8095274f1ee9723e272ee4d9ff0092b/responses-0.26.1.tar.gz"
    sha256 "2eb3218553cc8f79b57d257bac23af5e1bf381f5b9390b1767816f0843e01dc2"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e0/1f/12417f7f493fc45e1f9fd5d4a9b6c125cf8d2cf3f8ddbdfab3e76406e9d6/s3transfer-0.18.0.tar.gz"
    sha256 "3760b8b7ec1315da54048b2d626276732bee4300d054d492d4e1d43e20d4ecbd"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2d/9f/06263fcd8ad6c405f05a3905fd7a84dd3176eb5ad46e44bccc0cd16348bb/wrapt-2.2.1.tar.gz"
    sha256 "6744f504375775d7609c82c8d3d94af1c9a6f05586984536905908ba905277b9"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def python3
    which("python3.14")
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"moto_server"]
    keep_alive true
    working_dir var
    log_path var/"log/moto.log"
    error_log_path var/"log/moto.log"
  end

  test do
    port = free_port
    pid = spawn bin/"moto_server", "--port=#{port}"

    expected_output = <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Buckets/><Owner><DisplayName>webfile</DisplayName><ID>bcaf1ffd86f41161ca5fb16fd081034f</ID></Owner></ListAllMyBucketsResult>
    XML
    assert_equal expected_output.strip, shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
