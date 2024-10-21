class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/b4/c0/6637d2d8e113d909ac794944e041928ba7d43c3b540a896501776a6024e2/moto-5.0.18.tar.gz"
  sha256 "8a7ad2f53a2e6cc9db2ff65c0e0d4b5d7e78bc00b825c9e1ff6cc394371e76e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47d5eb297e293b6b5160cae142501602558435ffaf3df6df9b576e4e022d2666"
    sha256 cellar: :any,                 arm64_sonoma:  "86d9b8cdba10b768b3a86672a50bd271b5e6a9ae2c2c1668571a5348ac9620ff"
    sha256 cellar: :any,                 arm64_ventura: "5a167fc31f541673640e342769b2d0750504cd7fb61335cadb0c4369be38e82b"
    sha256 cellar: :any,                 sonoma:        "b83c1ef641de0a924a9ec782934981c871bc55705ff707351cffc72c11e98ec7"
    sha256 cellar: :any,                 ventura:       "be315629d6478f6f956b87a07796646673fc47843d6a2446c11b72279933db6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "327ce52132f8bbee89dc47fc1fead3df46dff2dc1c023ac1430e4372018969e8"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/33/5f/2cdf6f7aca3b20d3f316e9f505292e1f256a32089bd702034c29ebde6242/antlr4_python3_runtime-4.13.2.tar.gz"
    sha256 "909b647e1d2fc2b70180ac586df3933e38919c85f98ccc656a96cd3f25ef3916"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/1c/41/fbd5be5d25c6bdceb92ecb5232a794eb7a3a9cfdf111f28b27cb3c19fb77/aws_sam_translator-1.91.0.tar.gz"
    sha256 "0cdfbc598f384c430c3ec064f6008d80c5a0d58f1dc45ca4e331ae5c43cb4697"
  end

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/e0/6c/8e7fb2a45f20afc5c19d52807b560793fb48b0feca1de7de116b62a7893e/aws_xray_sdk-2.14.0.tar.gz"
    sha256 "aab843c331af9ab9ba5cefb3a303832a19db186140894a523edafc024cc0493c"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6c/67/696b35f6cc39b37e94931e9376a501d07bf3a6bffdfd65074ca6c2620568/boto3-1.35.44.tar.gz"
    sha256 "7f8e8a252458d584d8cf7877c372c4f74ec103356eedf43d2dd9e479f47f3639"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b0/f6/64f55cd5ffafb78a530edec7972b60b86527595a7b298aea5930069a36fd/botocore-1.35.44.tar.gz"
    sha256 "1fcd97b966ad8a88de4106fe1bd3bbd6d8dadabe99bbd4a6aadcf11cb6c66b39"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/d2/3c/addcac7a96bd729943f684bcc6f7b47e810b7c5365aec0bcd160d41502f8/cfn_lint-1.17.2.tar.gz"
    sha256 "2ac2e41fbacc30b77cf4ac0f07d31593217afd7a52a10f83f0c124da74f58586"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/4f/d0/d9e52b154e603b0faccc0b7c2ad36a764d8755ef4036acbf1582a67fb86b/flask_cors-5.0.0.tar.gz"
    sha256 "5aadb4b950c4e93745034594d9f3ea6591f734bb3662e16e255ffbf5e89c88ef"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/2e/b5/ebc6fe3852e2d2fdaf682dddfc366934f3d2c9ef9b6d1b0e6ca348d936ba/graphql_core-3.2.5.tar.gz"
    sha256 "e671b90ed653c808715645e3998b7ab67d382d55467b7e2978549111bbabf8d5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/dc/56/be93d6e313d0e8c4be6f459dafeb543d8a5a663afa10cb4521363052f824/joserfc-1.0.0.tar.gz"
    sha256 "298a9820c76576f8ca63375d1851cc092f3f225508305c7a36c4632cec38f7bc"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/35/48/841137f1843fa215ea284834d1514b8e9e20962bda63a636c7417e02f8fb/jsondiff-2.2.1.tar.gz"
    sha256 "658d162c8a86ba86de26303cd86a7b37e1b2c1ec98b569a60e2ca6180545f7fe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/6d/86/08646239a313f895186ff0a4573452038eed8c86f54380b3ebac34d32fb2/jsonpath-ng-1.7.0.tar.gz"
    sha256 "f6f5f7fd4e5ff79c785f1573b394043b39849fb2bb47bcead935d12b00beab3c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/85/39/3a58b63a997b0cf824536d6f84fff82645a1ca8de222ee63586adab44dfa/jsonschema_path-0.3.3.tar.gz"
    sha256 "f02e5481a4288ec062f8e68c808569e427d905bedfecb7f2e4c69ef77957c382"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/2c/f0/f02e2d150d581a294efded4020094a371bbab42423fe78625ac18854d89b/lazy-object-proxy-1.10.0.tar.gz"
    sha256 "78247b6d45f43a52ef35c25b5581459e85117225408a4128a3daf8bf9648ac69"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/ee/fc/03c4a1db15b4365cddb7f18285267b599744a048f8e1a98759cf677e33f0/multipart-1.1.0.tar.gz"
    sha256 "ee32683f5c454740cd9139e1d6057053823da0729c426f156464f81111529ba1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "openapi-schema-validator" do
    url "https://files.pythonhosted.org/packages/5c/b2/7d5bdf2b26b6a95ebf4fbec294acaf4306c713f3a47c2453962511110248/openapi_schema_validator-0.6.2.tar.gz"
    sha256 "11a95c9c9017912964e3e5f2545a5b11c3814880681fcacfb73b1759bb4f2804"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/67/fe/21954ff978239dc29ebb313f5c87eeb4ec929b694b9667323086730998e2/openapi_spec_validator-0.7.1.tar.gz"
    sha256 "8577b85a8268685da6f8aa30990b83b7960d4d1117e901d451b5d572605e5ec7"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/9d/ed/e0e29300253b61dea3b7ec3a31f5d061d577c2a6fd1e35c5cfd0e6f2cd6d/pathable-0.4.3.tar.gz"
    sha256 "5c869d315be50776cc8a993f3af43e0c60dc01506b399643f919034ebf4cdcab"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "py-partiql-parser" do
    url "https://files.pythonhosted.org/packages/de/91/9d499c960abea0efda9e81aa62bd8dd1eab1daa12db9b3b0064fe2f8b3c7/py_partiql_parser-0.5.6.tar.gz"
    sha256 "6339f6bf85573a35686529fc3f491302e71dd091711dfe8df3be89a93767f97b"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/67/24/1d67c8974daa502e860b4a5b57ad6de0d7dbc0b1160ef7148189a24a40e1/responses-0.25.3.tar.gz"
    sha256 "617b9247abd9ae28313d57a75880422d55ec63c29d33d629697590a034358dba"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/07/37/b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409/setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/11/8a/5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890f/sympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0f/e2/6dbcaab07560909ff8f654d3a2e5a60552d937c909455211b1b36d7101dc/werkzeug-3.0.4.tar.gz"
    sha256 "34f2371506b250df4d4f84bfe7b0921e4762525762bbd936614909fe25cd7306"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/50/05/51dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958f/xmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
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
    pid = fork do
      exec bin/"moto_server", "--port=#{port}"
    end

    expected_output = <<~EOS
      <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01"><Owner><ID>bcaf1ffd86f41161ca5fb16fd081034f</ID><DisplayName>webfile</DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>
    EOS
    assert_equal expected_output.strip, shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
