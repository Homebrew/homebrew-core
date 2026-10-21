class Fastapi < Formula
  include Language::Python::Virtualenv

  desc "CLI for FastAPI framework"
  homepage "https://fastapi.tiangolo.com/"
  url "https://files.pythonhosted.org/packages/35/ae/3c8fe5ea133a13dbdb0c84e586087aa811f311cb11b00efdb11c364793e6/fastapi-0.150.0.tar.gz"
  sha256 "97583806e6de1b6fc299866bdb88730fa311ff640829af876c9e847f4c3a3b29"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "706b6daee1f9478f9ac00ad7c8216f7bbbe8585d3c9698c21eb65b02557f592a"
    sha256 cellar: :any, arm64_tahoe:       "dca8db7aa4d6c01c090a125b063fe614787f7b3a3d97ae01f84a351d1280e120"
    sha256 cellar: :any, arm64_sequoia:     "59946fcdc6d21c4dd03b2d014153c3502856d6b4abeeb23806b7a33489763da4"
    sha256 cellar: :any, arm64_linux:       "3dc55290a001ac3e7cc883a22794e425fa37d29e0e347d6efa0139e9b89d3bea"
    sha256 cellar: :any, x86_64_linux:      "032e5e271e698a300b8484d604b2a2cd70adfe99783b67a632346d411213cc80"
  end

  depends_on "rust" => :build # for annotated-doc
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name:     "fastapi[standard]",
                exclude_packages: ["certifi", "pydantic"]

  resource "agent-detector" do
    url "https://files.pythonhosted.org/packages/b3/92/2c3e2ad5ce9683876729034082af19cfb3fbafd1c298b22a0b0c10ecfdc5/agent_detector-2.0.0.tar.gz"
    sha256 "19c8ae185dbdca23c24abdcd8ac2cf58b8e84dc284c6f6db536656601f9ffc3f"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "detect-installer" do
    url "https://files.pythonhosted.org/packages/cd/eb/77b0cc7fc0235b0495b32410edebe14cf6757b826135a7f92bb0f5d843b9/detect_installer-0.2.1.tar.gz"
    sha256 "85f889d4d19c1caf5bef89ef389eb920cd8c6c2a868e1eeceec24527b93021e7"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "fastapi-cli" do
    url "https://files.pythonhosted.org/packages/33/eb/3b534c6f8e157f9ddbf2a153512307c886cad0b258739c200dd8ff8c4452/fastapi_cli-0.0.32.tar.gz"
    sha256 "38024d2345275e1b37ce8848727a580d84901b570e96b3256d9d36a9a5039424"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/c0/8a/2857421c2218426e9f7635f9796e4e4bb41116b4b96d2fdf0cf8ed9ab5ae/fastapi_cloud_cli-0.26.0.tar.gz"
    sha256 "5fd64c26228c8ead803461e8b58ae64ffd586e960d97ab1fc848efac2d9539be"
  end

  resource "fastar" do
    url "https://files.pythonhosted.org/packages/cc/52/5bee9a672f418008d34c708d66e89e8f6fed8f0812f406a1c92fb5e393a8/fastar-0.12.0.tar.gz"
    sha256 "bba71522eae6a7627a5514ffdd4ac9645ef27d82e23931d79fd974bb49c3f2ad"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/8d/2b/6ce81972d5c8cab9705fddce3153be63222d9e12fd96f8baba5038a744dd/googleapis_common_protos-1.75.5.tar.gz"
    sha256 "c7a866fc34ed29a3b10af627a4b9b1dc2433313ca6e959f0ae4feb132047ed72"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c2/a9/11bc39967bb9dfaab0981ab4d49f519818acbee662a7e76d06813319c838/httpcore2-2.15.1.tar.gz"
    sha256 "a94b6b3e6260e1a3f035915408d3dcd7dc8e844c2b544b642e227cf98a747af0"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/3a/ec/deed52912ab7ca6c0b12859330c571c60c61d7267b341b28951fcbf13694/httptools-0.9.0.tar.gz"
    sha256 "d484ebb7e3a3f3597b0f645fbd1b85633674ca808c1f5ba11c2caf7c66f5c8b6"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/7f/85/07978f4afd168d6b408fa75c1dc13e3010653a81e182aa1b6d89ab94d9c6/httpx2-2.15.1.tar.gz"
    sha256 "ff75485308fbe441e75b1218546e4e78d884df41e1a9741c1f79335ed8fcfef7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/2e/02/6e0ae9cc61bd3169d401077b507b3ebc344745171e1051ab430be012dcd9/opentelemetry_api-1.45.1.tar.gz"
    sha256 "aa38ed19bcc084ba42782a73255b3582283eced7ad6dddbd6695189e69adfb75"
  end

  resource "opentelemetry-exporter-http-transport" do
    url "https://files.pythonhosted.org/packages/62/0c/e3ebdb4b507f66afcc905e6885a4946969bd75b45988492643356fbbdc63/opentelemetry_exporter_http_transport-0.66b1.tar.gz"
    sha256 "443080203bf52586ce0b2ad901e8951c61833eab1aa539ae6f1f16fe9e8e7952"
  end

  resource "opentelemetry-exporter-otlp-common" do
    url "https://files.pythonhosted.org/packages/cb/19/41de712173f43057e4532d42ece7d0c6d4210d353e5752433cb14987643f/opentelemetry_exporter_otlp_common-0.66b1.tar.gz"
    sha256 "6b1403487a2185ac1feb45fd5546fdf8630ce71c36bcefaadf51e2130e9e23f9"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/c1/8e/65e85e5137991a3c493b11682151d198638a5bc1dd4b4c5f67e013c57d7c/opentelemetry_exporter_otlp_proto_common-1.45.1.tar.gz"
    sha256 "2e4adcc3a67bcf57804fc49514f0ef64974ca7590aa3491da389852b4a0628f6"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/1b/17/26487707ea4caa97b17e6e4b5fa72133a53512ffa2f5cf7a49ef284b29cb/opentelemetry_exporter_otlp_proto_http-1.45.1.tar.gz"
    sha256 "45c218405ce3fd879596924b1874bf9a8f6880206d61065c5a912c8e5c297fb7"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/4b/7f/15f014fb195da6c2dbb6c71399b8e76824878718e94de6454038488eed28/opentelemetry_proto-1.45.1.tar.gz"
    sha256 "79e0fb95e4616691a469439238aa9224d75779b3e108e895d1aa125ab29ca77c"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/a1/79/7392e21a1c8f0c61d90b223e31c7e48cb9d452e91a6b820ad24cca5f23c4/opentelemetry_sdk-1.45.1.tar.gz"
    sha256 "63d24a6ca645019a631e6a51999c73e93adcac1196ca640b8ae78a7cc4762bf3"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/46/e4/dbbfb2a010c4db2224a5114638acede6fe563d33cc20fb1752cebcbe6298/opentelemetry_semantic_conventions-0.66b1.tar.gz"
    sha256 "497ca63bf383723411e8eaf60c8779e9877633c936bb641080adab59d0eb6ec8"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "pydantic-extra-types" do
    url "https://files.pythonhosted.org/packages/66/71/dba38ee2651f84f7842206adbd2233d8bbdb59fb85e9fa14232486a8c471/pydantic_extra_types-2.11.1.tar.gz"
    sha256 "46792d2307383859e923d8fcefa82108b1a141f8a9c0198982b3832ab5ef1049"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/2e/3b/a5d2294799b53b448319978cfb5bd139d5a9d45e862af91661614f14c922/pydantic_settings-2.16.0.tar.gz"
    sha256 "5b6c578049ede4db0e2ef3b4eaa4ad4069cfa9211f83fb38df899dfade50a614"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-toolkit" do
    url "https://files.pythonhosted.org/packages/61/fe/e851890b72568a075a3574f760eed9014736b449fe104b16fd05a416c321/rich_toolkit-0.20.6.tar.gz"
    sha256 "04768f19438df877c6279e6e668ab0d88b5fff5c7ef3ac302838d97f7b03472e"
  end

  resource "rignore" do
    url "https://files.pythonhosted.org/packages/ff/7e/aa0640d74f6b4bb68466f5899bd5ed1680480732344c31a408504e215801/rignore-0.8.1.tar.gz"
    sha256 "2b6cf58501e9ff1b6a71c3fd66c8a105311e1f23237626fd4c9c00606bb3d30f"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/26/c1/d2bbb2b03bdc2ef14b35e02b647b8489156c50b6e0b8bacc5fa303902e23/sentry_sdk-2.72.0.tar.gz"
    sha256 "0d2ffbc28ee2e63cbaf3d015e93b448cffcc3ef3be03a44704ad36ade72faa95"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ad/eb/4e197bf26b023abafc5e9043ec8710d7de0fcb032d0969045236d72aa0b1/starlette-1.9.0.tar.gz"
    sha256 "3d931de246ed870e35ce605974440816ef895e592f255d1396cfdf191d4c4318"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/fa/42/02c739ce85fb2ee8d99212c61417da8140c6b87e9d97c430bea520d76044/uvloop-0.23.0.tar.gz"
    sha256 "28d160f51ab4da3b187063652e643dea6831072add4adc1e6d62afbe73b6be27"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/b3/68/e6aa0b77d217b31f8f486ec0cdfe5e00e6e38dc0be657e7d85819b9faf0a/watchfiles-1.3.0.tar.gz"
    sha256 "99aee4a07847c06820765fd7b1b49ceac4f3f711ccb7d104655a33231de1c207"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/30/4b/4692be6d5bf739ed049b3813901c42091f8c054df89d5c089343823dea0d/websockets-17.3.tar.gz"
    sha256 "1c7dd93a1c9f89297471493674b1fc1d9467cafd45374f2172213046bdb3a329"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/fastapi"

    generate_completions_from_executable(bin/"fastapi", shell_parameter_format: :typer)
  end

  test do
    port = free_port

    (testpath/"main.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/")
      async def read_root():
          return {"Hello": "World"}
    PYTHON

    pid = spawn bin/"fastapi", "dev", "--port", port.to_s, "main.py"
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}")
    assert_equal '{"Hello":"World"}', output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
