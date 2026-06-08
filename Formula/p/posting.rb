class Posting < Formula
  include Language::Python::Virtualenv

  desc "Modern API client that lives in your terminal"
  homepage "https://github.com/darrenburns/posting"
  url "https://files.pythonhosted.org/packages/5e/81/8e3c84cba1f0e83e0e2d0263e6cd2370ec66ebedfd58fa9fd330095965e1/posting-2.10.0.tar.gz"
  sha256 "4563f7c34bb0827a74b097490189f925fab825b1096e787c22171657531147f1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ede47906169e5af227a5859326c09bc1a865d301649f9a134c4f333ab9486e8e"
    sha256 cellar: :any,                 arm64_sequoia: "b0bd4272077714fd93c8dfd52be04f057f63da89b98e1567126f2ae30b83c4a7"
    sha256 cellar: :any,                 arm64_sonoma:  "4be2a91fb1ac9525efaeda4bf7a6e46c5fed92e601eb91761a05c43728cead93"
    sha256 cellar: :any,                 sonoma:        "cf65e69c4cdad097450701fc3e67b3f4cf3f8b8d3ea4adc40ee7cb8340921a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a56f685d5ffe45cdb1ddd6797b42af303b6d04bc85ac3b84c0dd79f3a31e6ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bcb33eccc3646ecef05229b70a7ee92241b46d6217a44b782610e43734e02fd"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for watchfiles

  depends_on "brotli"
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "tree-sitter" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/23/e4/796662cd90cf80e3a363c99db2b88e0e394b988a575f60a17e16440cd011/click-8.4.0.tar.gz"
    sha256 "638f1338fe1235c8f4e008e4a8a254fb5c5fbdcbb40ece3c9142ebb78e792973"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
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
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/07/60/1d1e59c9c90d54591469ada7d268251f71c24bdb765f1a8a832cee8c6653/pydantic_settings-2.14.1.tar.gz"
    sha256 "e874d3bec7e787b0c9958277956ed9b4dd5de6a80e162188fdaff7c5e26fd5fa"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/da/44/4b524b2f06e0fa6c4ede56a4e9af5edd5f3f83cf2eea5cb4fd0ce5bbe063/textual-6.1.0.tar.gz"
    sha256 "cc89826ca2146c645563259320ca4ddc75d183c77afb7d58acdd46849df9144d"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/1e/3a/80411bc7b94969eb116ad1b18db90f8dce8a1de441278c4a81fee55a27ca/textual_autocomplete-4.0.6.tar.gz"
    sha256 "2ba2f0d767be4480ecacb3e4b130cf07340e033c3500fc424fed9125d27a4586"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/8e/0e/f0108be910f1eef6499eabce517e79fe3b12057280ed398da67ce2426cba/tree_sitter_bash-0.25.1.tar.gz"
    sha256 "bfc0bdaa77bc1e86e3c6652e5a6e140c40c0a16b84185c2b63ad7cd809b88f14"
  end

  resource "tree-sitter-css" do
    url "https://files.pythonhosted.org/packages/38/37/7d60171240d4c5ba330f05b725dfb5e5fd5b7cbe0aa98ef9e77f77f868f5/tree_sitter_css-0.25.0.tar.gz"
    sha256 "2fc996bf05b04e06061e88ee4c60837783dc4e62a695205acbc262ee30454138"
  end

  resource "tree-sitter-go" do
    url "https://files.pythonhosted.org/packages/01/05/727308adbbc79bcb1c92fc0ea10556a735f9d0f0a5435a18f59d40f7fd77/tree_sitter_go-0.25.0.tar.gz"
    sha256 "a7466e9b8d94dda94cae8d91629f26edb2d26166fd454d4831c3bf6dfa2e8d68"
  end

  resource "tree-sitter-html" do
    url "https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7"
  end

  resource "tree-sitter-java" do
    url "https://github.com/tree-sitter/tree-sitter-java/archive/refs/tags/v0.23.5.tar.gz"
    sha256 "cb199e0faae4b2c08425f88cbb51c1a9319612e7b96315a174a624db9bf3d9f0"
  end

  resource "tree-sitter-javascript" do
    url "https://files.pythonhosted.org/packages/59/e0/e63103c72a9d3dfd89a31e02e660263ad84b7438e5f44ee82e443e65bbde/tree_sitter_javascript-0.25.0.tar.gz"
    sha256 "329b5414874f0588a98f1c291f1b28138286617aa907746ffe55adfdcf963f38"
  end

  resource "tree-sitter-json" do
    url "https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v0.24.8.tar.gz"
    sha256 "acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213"
  end

  resource "tree-sitter-markdown" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.1.tar.gz"
    sha256 "acaffe5a54b4890f1a082ad6b309b600b792e93fc6ee2903d022257d5b15e216"
  end

  resource "tree-sitter-python" do
    url "https://files.pythonhosted.org/packages/b8/8b/c992ff0e768cb6768d5c96234579bf8842b3a633db641455d86dd30d5dac/tree_sitter_python-0.25.0.tar.gz"
    sha256 "b13e090f725f5b9c86aa455a268553c65cadf325471ad5b65cd29cac8a1a68ac"
  end

  resource "tree-sitter-regex" do
    url "https://files.pythonhosted.org/packages/86/92/1767b833518d731b97c07cf616ea15495dcc0af584aa0381657be4ec446d/tree_sitter_regex-0.25.0.tar.gz"
    sha256 "5d29111b3f27d4afb31496476d392d1f562fe0bfe954e8968f1d8683424fc331"
  end

  resource "tree-sitter-rust" do
    url "https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v0.23.2.tar.gz"
    sha256 "71ce61738f8aff4531afed443572ca68aa74a66a07569a1d50863eb34787c782"
  end

  resource "tree-sitter-sql" do
    url "https://github.com/DerekStride/tree-sitter-sql/releases/download/v0.3.11/tree-sitter-sql-v0.3.11.tar.gz"
    sha256 "a97a324eae9c81ed68f6e162b9b33f8911fc6442caa2950e57c498e2460d1387"
  end

  resource "tree-sitter-toml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc"
  end

  resource "tree-sitter-xml" do
    url "https://github.com/tree-sitter-grammars/tree-sitter-xml/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9"
  end

  resource "tree-sitter-yaml" do
    url "https://files.pythonhosted.org/packages/57/b6/941d356ac70c90b9d2927375259e3a4204f38f7499ec6e7e8a95b9664689/tree_sitter_yaml-0.7.2.tar.gz"
    sha256 "756db4c09c9d9e97c81699e8f941cb8ce4e51104927f6090eefe638ee567d32c"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "xdg-base-dirs" do
    url "https://files.pythonhosted.org/packages/bf/d0/bbe05a15347538aaf9fa5b51ac3b97075dfb834931fcb77d81fbdb69e8f6/xdg_base_dirs-6.0.2.tar.gz"
    sha256 "950504e14d27cf3c9cb37744680a43bf0ac42efefc4ef4acf98dc736cab2bced"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"posting", shell_parameter_format: :click)
  end

  test do
    # From the OpenAPI Spec website
    # https://web.archive.org/web/20230505222426/https://swagger.io/docs/specification/basic-structure/
    (testpath/"minimal.yaml").write <<~YAML
      ---
      openapi: 3.1.1
      info:
        version: "0.0.0"
        title: Sample API
      servers:
        - url: http://api.example.com/v1
          description: Optional server description, e.g. Main (production) server
        - url: http://staging-api.example.com
          description: Optional server description, e.g. Internal staging server for testing
      paths:
        /users:
          get:
            summary: Returns a list of users.
            responses:
              '200':
                description: A JSON array of user names
                content:
                  application/json:
                    schema:
                      type: array
                      items:
                        type: string
      components: {}
    YAML

    output = shell_output("#{bin}/posting import minimal.yaml")
    assert_match "Importing OpenAPI spec from 'minimal.yaml'", output
    assert_path_exists testpath/"api_example_com_v1.env"
  end
end
