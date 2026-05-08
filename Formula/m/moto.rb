class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/a1/25/6aab597cc8ad992b6052e544130e8065d9639825b5a78728573b4f408750/moto-5.2.0.tar.gz"
  sha256 "be592dd93cc016a94afe2e2cae5de59c2df1cdd9d017c497d9a81e507ebe7fc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07c85fb882c064ce230e3d3861d43c0c477c5854a6f8468d98cafc4ec9156063"
    sha256 cellar: :any,                 arm64_sequoia: "eba0a4e7f976991571805a30b96d0b813b03269054f79f71d3ee0e7764d4e97e"
    sha256 cellar: :any,                 arm64_sonoma:  "29ac5eefcf73b4504fed4291ce6894b09f5a12896efd6359baf342952d4fd0f0"
    sha256 cellar: :any,                 sonoma:        "c5cee527398b32cdf179bc521a47d4f3f63a4888f873136241184b4ae022194a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f64055fe7815b9f11991fd7b7c57da77d1cd9482dcad05554ed95ad3928ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6788dce06c2ff5a85be974d50da9b6dbda9fa9be618a9694bc4bca5a066cd8d"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13" # Pydantic v1 is incompatible with Python 3.14, issue ref: https://github.com/aws/serverless-application-model/issues/3831
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
    url "https://files.pythonhosted.org/packages/e0/09/f62aa8d076f6ba85080ec6291e61af345e9be0daf8a4094101555e054ec7/aws_sam_translator-1.109.0.tar.gz"
    sha256 "0c5e60223ae8434ce0c6bdb9a491d69ba3ec97e15c0d825d3803f7806382d804"
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
    url "https://files.pythonhosted.org/packages/95/cd/bba36079f5d4bd63db7385e6b9dc1845db32407c3f18f56aaddafb75097f/boto3-1.43.2.tar.gz"
    sha256 "be951cc22769fbcda73fac523b031ee38db45c3ae2b0d828c76b8f6e8e683073"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2c/b0/65d4c85f16367fb6147d391652d0c386f24b029536f7026e7b98740166cd/botocore-1.43.2.tar.gz"
    sha256 "7b2ec87b6d0720bff920451ce930e71c2a99cdea48d0eaa66ccf0b21ea747e03"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/18/32/4a76cf04726f363fc213512a5e1d685ffe63c81e9a517f63ef23c1c30dd5/cfn_lint-1.50.1.tar.gz"
    sha256 "10df565e9774e41c4a5a1b6dca7d09765cd534bdf22dc24add5e4ad1e118699a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
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
    url "https://files.pythonhosted.org/packages/68/c5/36aa96205c3ecbb3d34c7c24189e4553c7ca2ebc7e1dd07432339b980272/graphql_core-3.2.8.tar.gz"
    sha256 "015457da5d996c924ddf57a43f4e959b0b94fb695b85ed4c29446e508ed65cf3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
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
    url "https://files.pythonhosted.org/packages/de/c6/de8fdbdfa75c8ca04fead38a82d573df8a82906e984c349d58665f459558/joserfc-1.6.4.tar.gz"
    sha256 "34ce5f499bfcc5e9ad4cc75077f9278ab3227b71da9aaf28f9ab705f8a560d3c"
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
    url "https://files.pythonhosted.org/packages/01/86/cfee6dd25843bec0760f456599a4f7e7e40221a934b9229fda0662c859bc/jsonschema_path-0.4.6.tar.gz"
    sha256 "c89eb635f4d497c9ac328eeff359c489755838806a7d033510a692e9576f5c4b"
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
    url "https://files.pythonhosted.org/packages/21/4b/67b24b2b23d96ea862be2cca3632a546f67a22461200831213e80c3c6011/openapi_schema_validator-0.8.1.tar.gz"
    sha256 "4c57266ce8cbfa37bb4eb4d62cdb7d19356c3a468e3535743c4562863e1790da"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/79/3f/aa0c1150627b4e683ae5673486b7d5cf2623a8821601863ee389e430965a/openapi_spec_validator-0.8.5.tar.gz"
    sha256 "93b04ef5321d5866b2502371123d86333e5c1444f051d323e02525d9e83c7622"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/72/55/b748445cb4ea6b125626f15379be7c96d1035d4fa3e8fee362fa92298abf/pathable-0.5.0.tar.gz"
    sha256 "d81938348a1cacb525e7c75166270644782c0fb9c8cecc16be033e71427e0ef1"
  end

  resource "py-partiql-parser" do
    url "https://files.pythonhosted.org/packages/56/7a/a0f6bda783eb4df8e3dfd55973a1ac6d368a89178c300e1b5b91cd181e5e/py_partiql_parser-0.6.3.tar.gz"
    sha256 "09cecf916ce6e3da2c050f0cb6106166de42c33d34a078ec2eb19377ea70389a"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/42/98/c8345dccdc31de4228c039a98f6467a941e39558da41c1744fbe29fa5666/pydantic_settings-2.14.0.tar.gz"
    sha256 "24285fd4b0e0c06507dd9fdfd331ee23794305352aaec8fc4eb92d4047aeb67d"
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
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/9f/b4/b7e040379838cc71bf5aabdb26998dfbe5ee73904c92c1c161faf5de8866/responses-0.26.0.tar.gz"
    sha256 "c7f6923e6343ef3682816ba421c006626777893cb0d5e1434f674b649bac9eb4"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2e/64/925f213fdcbb9baeb1530449ac71a4d57fc361c053d06bf78d0c5c7cd80c/wrapt-2.1.2.tar.gz"
    sha256 "3996a67eecc2c68fd47b4e3c564405a5777367adfd9b8abb58387b63ee83b21e"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def python3
    which("python3.13")
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
