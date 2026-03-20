class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/b2/3d/1765accbf753dc1ae52f26a2e2ed2881d78c2eb9322c178e45312472e4a0/moto-5.1.22.tar.gz"
  sha256 "e5b2c378296e4da50ce5a3c355a1743c8d6d396ea41122f5bb2a40f9b9a8cc0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "799b96283400a8a204f6337b5c0498e5ea389d6049c06103f8e401268d9e81e2"
    sha256 cellar: :any,                 arm64_sequoia: "9ea4552a4ec2bd5d4b9364b22d8d611c291cd1ebfe5c73beb9989bd7f50cb933"
    sha256 cellar: :any,                 arm64_sonoma:  "1965205f212cf6e1a31c6298e92a532366eb7cbe787b18d74a16149145a32916"
    sha256 cellar: :any,                 sonoma:        "9d6a0e1acddd66215423feaead5d3667b4d5fb3c832b24dc668aab3f0026e079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4189a8e1a2d14542162abf2ccdacca0aebdbc514b20d990fb77b9edac4ad6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cad47180114b7c7c700c39a7d529a340455b0d0a9e003dc49353bee77a49ee8"
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
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/d0/e3/82cc7240504b1c0d2d7ed7028b05ccceedb02932b8638c61a8372a5d875f/aws_sam_translator-1.103.0.tar.gz"
    sha256 "8317b72ef412db581dc7846932a44dfc1729adea578d9307a3e6ece46a7882ca"
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
    url "https://files.pythonhosted.org/packages/7f/2a/33d5d4b16fd97dfd629421ebed2456392eae1553cc401d9f86010c18065e/boto3-1.42.63.tar.gz"
    sha256 "cd008cfd0d7ea30f1c5e22daf0998c55b7c6c68cb68eea05110e33fe641173d5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/af/eb/a1c042f6638ada552399a9977335a6de2668a85bf80bece193c953531236/botocore-1.42.63.tar.gz"
    sha256 "1fdfc33cff58d21e8622cf620ba2bba3cff324557932aaf935b5374e4610f059"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/ee/b5/436c192cdf8dbddd8e09a591384f126c5a47937c14953d87b1dacacd0543/cfn_lint-1.41.0.tar.gz"
    sha256 "6feca1cf57f9ed2833bab68d9b1d38c8033611e571fa792e45ab4a39e2b8ab57"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/ce/90/b8cc8635c4ce2e5e8104bf26ef147f6e599478f6329107283cdc53aae97f/joserfc-1.6.3.tar.gz"
    sha256 "c00c2830db969b836cba197e830e738dd9dda0955f1794e55d3c636f17f5c9a6"
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
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/f1/6e/35174c1d3f30560848c82d3c233c01420e047d70925c897a4d6e932b4898/jsonschema-4.24.1.tar.gz"
    sha256 "fe45a130cc7f67cd0d67640b4e7e3e2e666919462ae355eda238296eafeb4b5d"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/5b/8a/7e6102f2b8bdc6705a9eb5294f8f6f9ccd3a8420e8e8e19671d1dd773251/jsonschema_path-0.4.5.tar.gz"
    sha256 "c6cd7d577ae290c7defd4f4029e86fdb248ca1bd41a07557795b3c95e5144918"
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
    url "https://files.pythonhosted.org/packages/10/de/0199b15f5dde3ca61df6e6b3987420bfd424db077998f0162e8ffe12e4f5/openapi_spec_validator-0.8.4.tar.gz"
    sha256 "8bb324b9b08b9b368b1359dec14610c60a8f3a3dd63237184eb04456d4546f49"
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
    url "https://files.pythonhosted.org/packages/52/6d/fffca34caecc4a3f97bda81b2098da5e8ab7efc9a66e819074a11955d87e/pydantic_settings-2.13.1.tar.gz"
    sha256 "b4c11847b15237fb0171e1462bf540e294affb9b86db4d9aa5c01730bdbe4025"
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
    url "https://files.pythonhosted.org/packages/8b/71/41455aa99a5a5ac1eaf311f5d8efd9ce6433c03ac1e0962de163350d0d97/regex-2026.2.28.tar.gz"
    sha256 "a729e47d418ea11d03469f321aaf67cdee8954cde3ff2cf8403ab87951ad10f2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
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
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
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
    url "https://files.pythonhosted.org/packages/61/f1/ee81806690a87dab5f5653c1f146c92bc066d7f4cebc603ef88eb9e13957/werkzeug-3.1.6.tar.gz"
    sha256 "210c6bede5a420a913956b4791a7f4d6843a43b6fcee4dfa08a65e93007d0d25"
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
      <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01"><Owner><ID>bcaf1ffd86f41161ca5fb16fd081034f</ID><DisplayName>webfile</DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>
    XML
    assert_equal expected_output.strip, shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
