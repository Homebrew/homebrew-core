class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/0f/4d/2671039ebc3ecbb15342ffc8d3d600fa8fa6225663698b12459df48819b0/moto-4.2.12.tar.gz"
  sha256 "7c4d37f47becb4a0526b64df54484e988c10fde26861fc3b5c065bc78800cb59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7abab081869989e7e81286aa3c404703d15b63f3fefa38a028d593d71e8fd78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27007a42ab51c5fdcd95a988f1a4a7c31cf2c24ad95ec783f800e3699850833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14d142bcb86a7ea1d853238ea429e8f9f41fb30848e946bc59dc3f2d832b9cd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "956e4470aaeca798ad8e6458dd7860885dcc958c7a187f0eb418cea670fbfff6"
    sha256 cellar: :any_skip_relocation, ventura:        "1d003c6d7372c9cbd0ddba6d4b4328817fe5b5840fc3dec12f6d5f38c5a56224"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac0928722f5b0e5e1b8b7e163a4d9ebfba56c3c749b7d10e5e37ad1da49a155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c243b874cff4932af5eba6c6ef3b96fe72673c359261105652bfaa247dad8aa"
  end

  depends_on "cffi"
  depends_on "cfn-lint"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/fe/57/dc276e064313ecec69179bb80a55704e68f4bf93276dcad6a9fa1feebaff/aws-xray-sdk-2.12.1.tar.gz"
    sha256 "0bbfdbc773cfef4061062ac940b85e408297a2242f120bcdfee2593209b1e432"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/c8/b0/bd7130837a921497520f62023c7ba754e441dcedf959a43e6d1fd86e5451/Flask-Cors-4.0.0.tar.gz"
    sha256 "f268522fcb2f73e2ecdde1ef45e2fd5c71cc48fe03cffb4b441c6d1b40684eb0"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/ee/a6/94df9045ca1bac404c7b394094cd06713f63f49c7a4d54d99b773ae81737/graphql-core-3.2.3.tar.gz"
    sha256 "06d2aad0ac723e35b1cb47885d3e5c45e956a53bc1b209a9fc5369007fe46676"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/dd/13/2b691afe0a90fb930a32b8fc1b0fd6b5bdeaed459a32c5a58dc6654342da/jsondiff-2.0.0.tar.gz"
    sha256 "2795844ef075ec8a2b8d385c4d59f5ea48b08e7180fce3cb2787be0db00b1fb4"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/6d/17/47bf2da4582a6d35a1254bc058258835a452698f97dade2ce9ed3dabd512/jsonschema_path-0.3.2.tar.gz"
    sha256 "4d0dababf341e36e9b91a5fb2a3e3fd300b0150e7fe88df4e55cc8253c5a3989"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/2c/f0/f02e2d150d581a294efded4020094a371bbab42423fe78625ac18854d89b/lazy-object-proxy-1.10.0.tar.gz"
    sha256 "78247b6d45f43a52ef35c25b5581459e85117225408a4128a3daf8bf9648ac69"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/1f/ce/8709efe606d05e591519c051deba36df346b165652b05e91c3e97eb6eb01/multipart-0.2.4.tar.gz"
    sha256 "06ba205360bc7096fefe618e4f1e9b2cdb890b4f2157053a81f386912a2522cb"
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

  resource "py-partiql-parser" do
    url "https://files.pythonhosted.org/packages/e9/80/47fab55e0c82c447ed2b5b484f4ae6a6c306365f16c4fd578fda56c93468/py-partiql-parser-0.5.0.tar.gz"
    sha256 "427a662e87d51a0a50150fc8b75c9ebb4a52d49129684856c40c88b8c8e027e4"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "python-jose" do
    url "https://files.pythonhosted.org/packages/e4/19/b2c86504116dc5f0635d29f802da858404d77d930a25633d2e86a64a35b3/python-jose-3.3.0.tar.gz"
    sha256 "55779b5e6ad599c6336191246e95eb2293a9ddebd555f796a65f838f07e5d78a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/a0/c5/2f4f243e9b9ddb2fa70d696fb66daafd8fde20c9663a4a22c6a02d61bd97/responses-0.24.1.tar.gz"
    sha256 "b127c6ca3f8df0eb9cc82fd93109a3007a86acb24871834c47b77765152ecf8c"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def python3
    which("python3.12")
  end

  def install
    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[cfn-lint].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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
