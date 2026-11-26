class Fastmcp < Formula
  include Language::Python::Virtualenv

  desc "Fast, Pythonic way to build MCP servers and clients"
  homepage "https://gofastmcp.com/getting-started/welcome"
  url "https://files.pythonhosted.org/packages/85/1d/9f024f5eef8be87e0a57dec143fdabd087adbbc27e9b3f52b1409be86e60/fastmcp-4.2.6.tar.gz"
  sha256 "df629f183202124342a2cad58b069b4058d8bb53696a015694e41b128bf21651"
  license "Apache-2.0"
  head "https://github.com/jlowin/fastmcp.git", branch: "main"

  bottle do
    manifest_sha256 "8ecdeda238ee4596cbabeb66b3ce658a406383bec225a8d9f7fb72720e6eb63f"
    sha256 cellar: :any, arm64_golden_gate: "269598103072540dce937d8a92899e35c6e4e14a3d220b9673d48e3ae30d024c"
    sha256 cellar: :any, arm64_tahoe:       "a1c4d1617284cdcea22319170755a545e24ac1a368e9409c001ad6df1a66dbd3"
    sha256 cellar: :any, arm64_sequoia:     "f0bf6e3d4d962e98afe0fec5b0b92da0f8ead63fd191276519a3bd7f455c6542"
    sha256 cellar: :any, arm64_linux:       "ac372c565ce49d40e23150951973839525b72938feb0b5f15d7e7dbee40cc92f"
    sha256 cellar: :any, x86_64_linux:      "a25e1eee89e07c521e1ede666eb2e64d0176db4942a7bb426f52c99aea6bca4b"
  end

  depends_on "rust" => :build # for py_key_value_aio
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "uv"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic rpds-py],
                extra_packages:   %w[jeepney secretstorage]

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/14/31/edb06aabd8f8f0b56d659f30800795f40b93cba96be946ce179f6931e3a5/aiofile-3.12.3.tar.gz"
    sha256 "caa6aa746b5e47e2165f7abd741b6415e49cf4d44fddc0f61844612cc3924d41"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/79/34/c0cfdaee9c796c8381439fed0fcab62810753b8b0adb1ec88fa7f41eaa5d/beartype-0.23.1.tar.gz"
    sha256 "8b805f246b32931c74f2b321ea0939fe5bb2ff43c12a3eff19cc4c854b832e1d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/75/28/eb1ac766e4c0c439506a654186de8e2cfcd99035218a9393986103a0fdf0/cachetools-8.0.2.tar.gz"
    sha256 "30ac523adfc118b51d2b2e7bad8a0ddb31370dfe2700c7f10ca224f36ccf81e0"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/66/66/a36d1367bd5ef70b6b97b2fb502f682106555e9e49e229f35c0a49d154d5/caio-0.12.10.tar.gz"
    sha256 "5cecc44c04d5c6291d98b61bdba999f49a7e58dff2d782b4bb0642dc6f7ecf58"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/ca/08/3cac2b682eb7cf561fe886d8322b3b65025193ed8753877ad3d9616aca45/cyclopts-5.5.3.tar.gz"
    sha256 "784ddcc8847f69f96e6ff1b4222c8939ba8f47cea516b8eafb8f56c4a4fa5900"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/c0/4d/f5e9d9de19f4b8f9e33d802fe3efb0ef96e88d4d6d45d604f335bef2f1ef/email_validator-2.4.0.tar.gz"
    sha256 "be487bc50bc3bd832a98515a55a15649d9bec06d954fa178663190714b6c4ee1"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/85/ac/f882fe3234606340c8729372da0fb98c634b97a560c9d375d9afea21496b/exceptiongroup-1.3.2.tar.gz"
    sha256 "ca82e69f0cb535fbde934885744b67669a3efddd50fe7bc00d3398839fcaddec"
  end

  resource "fastmcp-slim" do
    url "https://files.pythonhosted.org/packages/b6/2e/1dd46ee862200b104f57833c88db89f5203bef50090b4e74812b8326f372/fastmcp_slim-4.2.6.tar.gz"
    sha256 "15467ae9bb3fc80897dec7b37eab5310b47b75066b56720e286a3c08fd469577"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/36/e2/0f5d8ed08766bc6dcd3eebf5a6623d83cbca33a6e4c90aef57156ce745ad/griffelib-2.4.1.tar.gz"
    sha256 "40c028dd2e623f464423f0e11e3c553158f1cf4f1368239a370534d73e1407ff"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/92/9d/df40b41f7db0370f82019820709244e7b660c52aa3da3c9e5c4e8141f6e6/httpcore2-2.16.2.tar.gz"
    sha256 "6c519d0f7b44f7269fa9bbb4d2763db395a4a2370f046d8e8e0a4b38227815d2"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/1c/77/6515121dc5ac3c743ad1bff5afe635bcd1a3f23cc40db3c5c89f7d02917d/httpx2-2.16.2.tar.gz"
    sha256 "748b615678f07d8e3b183efe81ad13b655ca88bfc56ce4589219b2d442860574"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/74/31/5c3f27e82c92a7bbe1f028033ff19e0251540395c9be244c01a50de42bdb/joserfc-1.8.0.tar.gz"
    sha256 "cbf03cb2c6db8cc5289f1ef8718842e53dba244b4c0de5fefa0c0eaee4bde8db"
  end

  resource "jsonref" do
    url "https://files.pythonhosted.org/packages/aa/0d/c1f3277e90ccdb50d33ed5ba1ec5b3f0a242ed8c1b1a85d3afeb68464dca/jsonref-1.1.0.tar.gz"
    sha256 "32fe8e1d85af0fdefbebce950af85590b22b60f9e95443176adbde4e1ecea552"
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

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/9d/8d/e0d339616f4810e9051d4aba6887afab289ab1f81875fe908b606cdfd0e3/mcp-2.3.0.tar.gz"
    sha256 "8b147a50441cf059dc88c684e0aeed3687f0aa0f39c6cde7b90330effd2b34d8"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/9e/2d/7c251e34207f6c51000312fc8839111ac45cfe02023f90b44e7f1051dd8e/mcp_types-2.3.0.tar.gz"
    sha256 "d1e46549edb35ee19a94940fcee6d1addd7e589ab7ea92dda83f5d84781fc362"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/2b/32/0c9bd3e4e847cd6117b64dbef4cf810faa9cdbd6689323b811569cc8a1b8/openapi_pydantic-0.6.0.tar.gz"
    sha256 "11f3ac6ad41521fc156381ec587246b0c0ecea523bd9565ed74d3e7fac9d91cd"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/66/f3/5a20387de9bcd0607871bfc2198ee0e15836da7baa4592ccd7f24c27c986/pathable-0.6.0.tar.gz"
    sha256 "6404b8b82aef5ff0fd478934137128b99b12212ba35afdde5525ca4f8388ea58"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/42/dd/c3dc36b227fccce1ba6e049784fc4b77b7119702fc7cf50afe84f5f35be4/py_key_value_aio-0.5.0.tar.gz"
    sha256 "20808520093cf8ae005a0ecb89a0cf1875859b48f1087f4ba262b3adc1f80c5b"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/59/28/227c843eedd29bd78e132e5aafa420d83154b10465c312f9c21ff2eaf77d/pydantic_settings-2.16.3.tar.gz"
    sha256 "10e36f616623ebb586c05ca3d3cd22927146869db413d4f14c20c514442a1337"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/7e/c0/c753d487a83d873f6946cee6cbc26cea3fe59a476ad0de99a14938a2fbd8/python_multipart-0.0.34.tar.gz"
    sha256 "b998ae90ca6e1e363261ce2e0e230281b8af53867b757970abd69ee9edcd843a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/cf/0e/faf7c7e36630561e3e9611730c47510cd972dd5fde8f95941ff78f76accd/rich_rst-2.2.0.tar.gz"
    sha256 "b1e6a67f8f694a6f36035624bf73e2b1a0a4be13edaf3ba5e654d9758b61073a"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/12/c0/eb8c9eec5c0e29ce2a1c4d4654ddfb06c77b52b4db63ab40226198456be6/sse_starlette-3.7.1.tar.gz"
    sha256 "9a8256e3e80a0fdc8d1dec14f2bb0b3f304c99f23a6d4d26c61ff50145761597"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "uncalled-for" do
    url "https://files.pythonhosted.org/packages/a3/60/993a9757dc4a41727351828dc784e66fd467ed81d46cbec25d44cae69657/uncalled_for-0.6.2.tar.gz"
    sha256 "58835db667a85408c7b6d6ad8dfdd74d7713d3be669b46396ba3d2c6a889242d"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
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
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)

    bin.install_symlink libexec/"bin/fastmcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastmcp --version")

    (testpath/"server.py").write <<~PYTHON
      from fastmcp import FastMCP

      mcp = FastMCP("Demo 🚀")

      @mcp.tool
      def add(a: int, b: int) -> int:
          return a + b
    PYTHON

    port = free_port
    ENV["FASTMCP_STATELESS_HTTP"] = "1"
    with_test_process(bin/"fastmcp", "run", "server.py:mcp", "--transport=http", "--port=#{port}", "--no-banner") do
      data = <<~JSON
        {
          "jsonrpc": "2.0",
          "id": "1",
          "method": "tools/call",
          "params": {
            "name": "add",
            "arguments": {"a": 1, "b": 2}
          }
        }
      JSON

      system "curl", "--silent",
                     "--retry", "5",
                     "--retry-connrefused",
                     "--request", "POST",
                     "--header", "Content-Type: application/json",
                     "--header", "Accept: text/event-stream, application/json",
                     "--output", testpath/"response.txt",
                     "--data", data,
                     "http://127.0.0.1:#{port}/mcp"
      assert_match '{"result":3}', (testpath/"response.txt").read
    end
  end
end
