class Kaskade < Formula
  include Language::Python::Virtualenv

  desc "TUI for Kafka"
  homepage "https://github.com/sauljabin/kaskade"
  url "https://files.pythonhosted.org/packages/37/3b/88be2113f39216a6ad36680ad599927cbb57dbd9eef9f4af3af138134187/kaskade-4.0.7.tar.gz"
  sha256 "cd907eb673d733ba27f4f89b649ad6bf19cd829745ae0dd8879989eb5a6bcc36"
  license "MIT"
  head "https://github.com/sauljabin/kaskade.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a0b4f69740303178b241fab280528e7b6786d37f41c809fdcef7c8030733b77"
    sha256 cellar: :any,                 arm64_sequoia: "de31a4b1777549c98ebe2e52acfbb4131b4f2f38e59b20ad965817c2c8b77f82"
    sha256 cellar: :any,                 arm64_sonoma:  "52c7b0d7f23984affbce96568891d3e8cabe9d1d7e432735eac6cb839d2764f2"
    sha256 cellar: :any,                 sonoma:        "9bd31a6a848e676de53ecafcf232cbf81bdc8be2570c30f8749e99b3fa5d5f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b110ebc3de34b8ad8437b240f767577af38b6dc903ae3ccbd98181688926c5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1085ed04cb87886a080537d5fc62959ff77346f8b80729acc5b891ec08b14557"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "librdkafka"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography rpds-py]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/af/98/00d3dd826d46959ad8e32af2dbb2398868fd9fd0683c26e56d0789bd0e68/authlib-1.6.9.tar.gz"
    sha256 "d8f2421e7e5980cc1ddb4e32d3f5fa659cfaf60d8eaf3281ebed192e4ab74f04"
  end

  resource "avro" do
    url "https://files.pythonhosted.org/packages/60/00/af1eec633637e12d0945a97f05a429eed83ac45865af60cb453db4689d95/avro-1.12.1.tar.gz"
    sha256 "c5b8dd2dd4c10816f0dc127cc29cfd43b5e405cf7e6840e89460a024bf3d098d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/d4/07/56595285564e90777d758ebd383d6b0b971b87729bbe2184a849932a3736/cachetools-7.0.1.tar.gz"
    sha256 "e31e579d2c5b6e2944177a0397150d312888ddf4e16e12f1016068f0c03b8341"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/46/cf/09a31f0f51b5c8ef2343baf37c35a5feb4f6dfdcbd0592a014baf837f2e4/cloup-3.0.8.tar.gz"
    sha256 "f91c080a725196ddf74feabd6250266f466e97fc16dfe21a762cf6bc6beb3ecb"
  end

  resource "confluent-kafka" do
    url "https://files.pythonhosted.org/packages/7a/38/f5855cae6d328fa66e689d068709f91cbbd4d72e7e03959998bd43ac6b26/confluent_kafka-2.13.2.tar.gz"
    sha256 "619d10d1d77c9821ba913b3e42a33ade7f889f3573c7f3c17b57c3056e3310f5"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/65/8b/fa2d3287fd2267be6261d0177c6809a7fa12c5600ddb33490c8dc29e77b2/fastavro-1.12.1.tar.gz"
    sha256 "2f285be49e45bc047ab2f6bed040bb349da85db3f3c87880e4b92595ea093b2b"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/53/45/b268004f745ede84e5798b48ee12b05129d19235d0e15267aa57dcdb400b/orjson-3.11.7.tar.gz"
    sha256 "9b1a67243945819ce55d24a30b59d6a168e86220452d2c96f4d1f093e71c0c49"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ba/25/7c72c307aafc96fa87062aa6291d9f7c94836e43214d43722e86037aac02/protobuf-6.33.5.tar.gz"
    sha256 "6ddcac2a081f8b7b9642c09406bc6a4290128fce5f471cddd165960bb9119e5c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/fb/e4/0f6b6c22a30d2dc2850b4d09c8684742cc4ab79501d4588ea05269c1de3f/textual-8.0.1.tar.gz"
    sha256 "fe6544e57651a7c2a8249b90ec542b45fa945ce4560e69b0d563fb440e7c4db3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"kaskade", shell_parameter_format: :click)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/kaskade admin -b localhost:9092")
    assert_match "\e[?1049h\e[?1000h\e[?1003h\e[?1015h\e[?1006h\e[?25l", r.readline

    assert_match version.to_s, shell_output("#{bin}/kaskade --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
