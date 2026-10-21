class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/55/53/f2214b9103621c114c4835db908c350b0f1360bc696fa4f3348d7baa6b74/langgraph_cli-0.4.37.tar.gz"
  sha256 "a24ac16135a72de158576aba358d731c33372dc0ab4caa6f9f8618c70942c638"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "40b1263b55aa1fda9f46fbbf43493bd419072653611e5d9d517d4f91bb754aac"
    sha256 cellar: :any, arm64_tahoe:       "4f1ecd3f6abe1effd7cc01ba4967fd818ed6fb45122370b487fe140db479a020"
    sha256 cellar: :any, arm64_sequoia:     "26b43b2bb734d67f9f8bf6f77ef4885283bcf87bdce1528d3a457fc63b3ac704"
    sha256 cellar: :any, arm64_linux:       "c289de5aaa57326ec02387ffb1cbe5044d6838a381bdcd20a97546ce46064de5"
    sha256 cellar: :any, x86_64_linux:      "553bcfab0456d40ca03412384c226cc5c5814cb7b44ed5cfae86bf3ef9edf996"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "xxhash"
  depends_on "zstd"

  pypi_packages exclude_packages: %w[certifi pydantic]

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

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
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
    url "https://files.pythonhosted.org/packages/30/ff/b53af1b49bb2cb5fa97c92215614b173ca5c1a99ded80e2d52f15a94fa6d/httpcore2-2.14.0.tar.gz"
    sha256 "4f57a1a8249fe6af589d935cfd456f1d13bbdcb0f0fc72af9142368fc94811d7"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/e8/67/58353f1848b4ba568e1ec22ea1e0d8e039f0bca5fde7e2d1f07739fd83e7/httpx2-2.14.0.tar.gz"
    sha256 "47ad61a3c40282cd8d0dc96311531f00f5bfc71a066c6fe3b36d8f63fb9e4f6e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/8e/39/c534bb172e9318400d5631074b1eda6c78b7c918d0f04233b50caa8e2c10/jsonpatch-1.36.tar.gz"
    sha256 "7e110cb3c5a1c8768f7170bf8fb9887c4aa575fba74c95239e868b494bd9a522"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/77/9be5cce647fa4d7afa9047c0c1029bc73292c27430e64fc9d2393ccf6727/jsonpointer-3.4.tar.gz"
    sha256 "e57015ae65af3821c6a3976069860789cf326103f38b22b2178d41d021adad25"
  end

  resource "langchain-core" do
    url "https://files.pythonhosted.org/packages/12/c2/9779d64322d4e270f6d5392bc86b30f735581a87b5eefd6ad15a0828a169/langchain_core-1.6.12.tar.gz"
    sha256 "dc6b2a965c351b4cc94df1c80220bcf3c5472e14437d2186c8290ea22f4d0219"
  end

  resource "langchain-protocol" do
    url "https://files.pythonhosted.org/packages/14/56/913599f2f9cec8524868929f12d72b2ede377a6056ca8a40a32bdadfa535/langchain_protocol-0.0.19.tar.gz"
    sha256 "79d90a1425122ac87e8052e2ec054fbd09c3edbf341bdfb6397112a495c7bf8c"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/5e/2a/bb6b4ca7a735901542c885e59ce3d1a128e2914b072b0c9a9feaf927195a/langgraph_sdk-0.4.8.tar.gz"
    sha256 "6dd0c55d0d9040686716581c9e302c21c31ad6e2eebda0defc944a8bb38ec011"
  end

  resource "langsmith" do
    url "https://files.pythonhosted.org/packages/f8/c3/a9a98d7adf573fdd5ea5c92cadbc26d7c597ab36f4dc31c093eb19507808/langsmith-0.14.11.tar.gz"
    sha256 "d9e7ffe587e12ce51573cab654d02e84feb924d3b1f582274c4b1412ebeabf4c"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/82/9e/497c1c8ebe5a5b5d1d4a7511aea22c0bb1a97e3170d98abdef0e1b34265a/tenacity-9.2.1.tar.gz"
    sha256 "a606b5c808d0cded4a359d5b9932d867ff2a6a6b64d37350260fd01bbdf83839"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uuid-utils" do
    url "https://files.pythonhosted.org/packages/d1/89/3720bd4ef165d9694530290d4bf639f4b45b92b28279f7e37acade45d14c/uuid_utils-0.18.0.tar.gz"
    sha256 "20e21f57fdc985132c65ab19c03c08c06f186f5bae62fc8a88ea84365ba9da37"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/39/e6/ed6c428055ffd3f9299db3ec8671fd78b70c24173c040b8faafb6348ebbb/xxhash-4.0.2.tar.gz"
    sha256 "af3d1b3cfa5280e84d8968e9f30c9eca75781db4915eb6d6acb0dd4fc93e0f47"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    ENV["XXHASH_LINK_SO"] = "1"
    venv = virtualenv_install_with_resources without: "zstandard"

    resource("zstandard").stage do
      args = std_pip_args(prefix: false, build_isolation: true)
      args << "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", *args, "."
    end

    generate_completions_from_executable(bin/"langgraph", shell_parameter_format: :click)
  end

  test do
    (testpath/"graph.py").write <<~PYTHON
      from langgraph.graph import StateGraph
      builder = StateGraph(list)
      builder.add_node("anode", lambda x: ["foo"])
      builder.add_edge("__start__", "anode")
      graph = builder.compile()
    PYTHON

    (testpath/"langgraph.json").write <<~JSON
      {
        "graphs": {
          "agent": "graph.py:graph"
        },
        "env": {},
        "dependencies": ["."]
      }
    JSON

    system bin/"langgraph", "dockerfile", "DOCKERFILE"
    assert_path_exists "DOCKERFILE"
    dockerfile_content = File.read("DOCKERFILE")
    assert_match "FROM", dockerfile_content, "DOCKERFILE should contain 'FROM'"
  end
end
