class Fastapi < Formula
  include Language::Python::Virtualenv

  desc "CLI for FastAPI framework"
  homepage "https://fastapi.tiangolo.com/"
  url "https://files.pythonhosted.org/packages/4e/7b/ae546e10f153fcf9a6afd8b9fe4730bdfeb8fdcb93178d54122973ef3f4c/fastapi-0.162.5.tar.gz"
  sha256 "1ca37f64f61c99cebd38636e67525fb721c5e8c1169f07f2a35d73b0a63265d4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee4beef83c696855042ac5a53d1d616c84e1c091f3c87c270579aed37bd9e514"
    sha256 cellar: :any, arm64_tahoe:       "5368595c27c0aeb5d3afa43cdd2349cd4d4eb48fae5c548903304efb50d91c8b"
    sha256 cellar: :any, arm64_sequoia:     "0e528e819a53767ab25d544a312f3791354ec0ef3fc870fd69d2d4c3d6365113"
    sha256 cellar: :any, arm64_linux:       "fa8c4d79d86c05dec04758f63bca0ecdefb3db3d3d633855671d15c0f4db28e8"
    sha256 cellar: :any, x86_64_linux:      "913920f9d6600055fd32496c676a2296406b80234805b7e42d2ed3ca2baf6aa7"
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
    url "https://files.pythonhosted.org/packages/0f/6e/a61e86e43bb6039b31a33a8f5fba76fe1cdacf3661e7b9756d4ff1b28cdc/annotated_doc-0.0.6.tar.gz"
    sha256 "7969bb69912085b2285849c0dcac0b4b374fd180c13cf10a87f284ffcf347bbf"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "detect-installer" do
    url "https://files.pythonhosted.org/packages/cd/eb/77b0cc7fc0235b0495b32410edebe14cf6757b826135a7f92bb0f5d843b9/detect_installer-0.2.1.tar.gz"
    sha256 "85f889d4d19c1caf5bef89ef389eb920cd8c6c2a868e1eeceec24527b93021e7"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "fastapi-cli" do
    url "https://files.pythonhosted.org/packages/41/8c/d2fe2da44fe68a442bbfea5e6436e2de7829c0c2d419a7c314e2e91ae95f/fastapi_cli-0.0.33.tar.gz"
    sha256 "94f19bcde4bd6ae26328292ac864082543262b7ee9f5d11bd7224614c22fb958"
  end

  resource "fastapi-cloud-cli" do
    url "https://files.pythonhosted.org/packages/97/c7/3b7c8eb16c5777c40c3b5ef675804796b92a9cde96fd0aa9c85cde3b0449/fastapi_cloud_cli-0.28.0.tar.gz"
    sha256 "7e70611d3f3f1f3bbd48cf5def95db927566f9668929cec96bc34dd632f09963"
  end

  resource "fastar" do
    url "https://files.pythonhosted.org/packages/cc/52/5bee9a672f418008d34c708d66e89e8f6fed8f0812f406a1c92fb5e393a8/fastar-0.12.0.tar.gz"
    sha256 "bba71522eae6a7627a5514ffdd4ac9645ef27d82e23931d79fd974bb49c3f2ad"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
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
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
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
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
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
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
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
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "opentelemetry-exporter-http-transport" do
    url "https://files.pythonhosted.org/packages/a6/e6/dbeb3e217418071656232a4028c791060d219f218cef1249b664049d12c0/opentelemetry_exporter_http_transport-0.66b2.tar.gz"
    sha256 "66d6ed810a515432c8891da9a834464332fd70badeca45bdeeae81b4280c903b"
  end

  resource "opentelemetry-exporter-otlp-common" do
    url "https://files.pythonhosted.org/packages/5a/3c/3f2cc8c42bde2620e65024d71e2eb025f7bd0821bb363b52bcc5a3260dbd/opentelemetry_exporter_otlp_common-0.66b2.tar.gz"
    sha256 "06f5a9b88638e310efa1f1d206cdf6b75393e112aba4e174a963416192bd1028"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/69/58/239c98b36d9ea317098769957043c251703636a26189c884fba46c1dad84/opentelemetry_exporter_otlp_proto_common-1.45.2.tar.gz"
    sha256 "f1f2806f3f28ce7938033823e50934fcd91595a39de38e69a28a51e19f40fc6d"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/db/07/b7b01ecb69d02f540e679a9e36f7413d081f225bbbed4469d212ada10bb7/opentelemetry_exporter_otlp_proto_http-1.45.2.tar.gz"
    sha256 "5984a3fb46bc4628e4e2b85d4a6e72637e03962aae6cf372791137768a4ad939"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/24/9c/1aa4ce60e9bc72af20dc49c92cc0566825092d92b3d6a277439fb5fb7c01/opentelemetry_proto-1.45.2.tar.gz"
    sha256 "bd8d23cf770605b0af9b7be2071d26a464fea289d35429abfd2a66226114ad64"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/7b/1a/74a21d4d6969fb8b432ac397e66112a8167a6deb267ea4559dbaf2fe91ef/opentelemetry_sdk-1.45.2.tar.gz"
    sha256 "7eec4de13dd21ff3a1670dcb0e02079e692736f94d733dfdce5af461d884248d"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/37/3f/50f95972b50e8e353f5b9342034c9cd17730f1956f009ce6a3fbbd89f9ce/opentelemetry_semantic_conventions-0.66b2.tar.gz"
    sha256 "7da5f1a5dc4383eb66711d4d3d3e71824d9403ac1559fea021cc103c1a4c4976"
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
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
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
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
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
    url "https://files.pythonhosted.org/packages/8e/7f/1b16ab4aee53cc5db976bac12e6df5d562aae3880965200cef812e7121d9/sentry_sdk-2.74.0.tar.gz"
    sha256 "dd91d75aacaef636006b579ac3ddb2fdbc9dce35f00f4b353b6b1b110c6b256a"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/6c/aa/0de7986aa1fa856adb961c67345189b97d13f6e250b34ba68884df865f07/typer-0.29.1.tar.gz"
    sha256 "ab6eb3880bf67ce96147734717f9ec333c06f66e361f3ea947d0be43da39f242"
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
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
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
