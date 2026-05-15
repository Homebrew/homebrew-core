class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/b4/b5/b989d41c63390dfc2bf63275ab543b82fed076723d912055e77ccbae1422/python_lsp_server-1.14.0.tar.gz"
  sha256 "509c445fc667f41ffd3191cb7512a497bf7dd76c14ceb1ee2f6c13ebe71f9a6b"
  license "MIT"
  revision 2
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5eddadab2ba013f664643a1beea1f1da6953b552b06c4ad948ab3a9efbbba959"
    sha256 cellar: :any,                 arm64_sequoia: "def6b365897eb45f20596caa323aced6fcbc6848313bf5a6f27cbe19d3413c4f"
    sha256 cellar: :any,                 arm64_sonoma:  "3928460a9ee2ed672e4b6cc5e44ef36b8def6434fe70afb71477c3e13bb7d3b1"
    sha256 cellar: :any,                 sonoma:        "609ac114ebf51451961ad3d492bc467789fe1dfdedfb083376984858277c7c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70935eb3bd9265d19964b051fbb625a4c7efcf96cb63cb1449e7e12eaa7a2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc9136f29766b2d86c4e4fd7e98141e8be579ac352cf1cbd9a72d16d764ca32"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages package_name:   "python-lsp-server[websockets]",
                extra_packages: %w[python-lsp-black pylsp-mypy python-lsp-ruff pylsp-rope]

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/a9/9d/912fefab0e30aee6a3af8a62bbea4a81b29afa4ba2c973d31170620a26de/ast_serialize-0.3.0.tar.gz"
    sha256 "1bc3ca09a63a021376527c4e938deedd11d11d675ce850e6f9c7487f5889992b"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/e1/c5/61175d618685d42b005847464b8fb4743a67b1b8fdb75e50e5a96c31a27a/black-26.3.1.tar.gz"
    sha256 "2c50f5063a9641c7eed7795014ba37b0f5fa227f3d408b968936e24bc0566b07"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/d8/8abe80d62c5dce1075578031bcfde07e735bcf0afe2886dd48b470162ab4/docstring_to_markdown-0.17.tar.gz"
    sha256 "df72a112294c7492487c9da2451cae0faeee06e86008245c188c5761c9590ca3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a9/01/15bb152d77b21318514a96f43af312635eb2500c96b55398d020c93d86ea/importlib_metadata-9.0.0.tar.gz"
    sha256 "a4f57ab599e6a2e3016d7595cfd72eb4661a5106e787a95bcc90c7105b831efc"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/72/3a/79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17a/jedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/40/08/9e7f6b5d2b5bed6ad055cdd5925f192bb403a51280f86b56554d9d0699a2/librt-0.11.0.tar.gz"
    sha256 "075dc3ef4458a278e0195cbf6ac9d38808d9b906c5a6c7f7f79c3888276a3fb1"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/82/15/cca9d88503549ed6fedeaa1d448cdddd542ee8a490232d732e278036fbf2/mypy-2.1.0.tar.gz"
    sha256 "81e76ad12c2d804512e9b13240d1588316531bfba07558286078bfbce9613633"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/30/4b/90c937815137d43ce71ba043cd3566221e9df6b9c805f24b5d138c9d40a7/parso-0.8.7.tar.gz"
    sha256 "eaaac4c9fdd5e9e8852dc778d2d7405897ec510f2a298071453e5e3a07914bb1"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/76/16/af7bc6a6b89e22d754823935bc8e82df3b97df5daba37b12ee1627fc8d61/pylsp_mypy-0.7.1.tar.gz"
    sha256 "4465a9b5f7816f02579f1398e369cae953952c7d2aaa9cab35e7a554e242b766"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/51/3d/cfcf7e093c98cccadbccdc8762194cd3afaa4d8aac6731ced5bea92489cb/pylsp_rope-0.1.17.tar.gz"
    sha256 "4cd6f2fb32c84302b94cb4ce002bc0700b1b656dd5147e7db3dd92303a9a8dc2"
  end

  resource "python-lsp-black" do
    url "https://files.pythonhosted.org/packages/c0/48/06edc947f711fb076b564ee97bbecb5ae877816ccc0edf4347f57cd9d6b9/python-lsp-black-2.0.0.tar.gz"
    sha256 "8286d2d310c566844b3c116b824ada6fccfa6ba228b1a09a0526b74c04e0805f"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/48/b6/fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557b/python-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/43/17/dc7475750fbc89a06fe9c6efc5bf8ff06813eb77e3b6c5d770a23b0d0f3d/python_lsp_ruff-2.3.1.tar.gz"
    sha256 "37831ae9bd498214b13ea1e73df7fe5721c7055534c644efbb81c52069e73341"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/18/dc/abf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743db/pytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/74/3a/85e60d154f26ecdc1d47a63ac58bd9f32a5a9f3f771f6672197f02a00ade/rope-1.14.0.tar.gz"
    sha256 "8803e3b667315044f6270b0c69a10c0679f9f322ed8efe6245a93ceb7658da69"
  end

  resource "ruff" do
    url "https://files.pythonhosted.org/packages/99/43/3291f1cc9106f4c63bdce7a8d0df5047fe8422a75b091c16b5e9355e0b11/ruff-0.15.12.tar.gz"
    sha256 "ecea26adb26b4232c0c2ca19ccbc0083a68344180bba2a600605538ce51a40a6"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/bc/78/937198ea8708182dd1edbf0237bf255a96feab3f511691ad08b84da98e5d/ujson-5.12.1.tar.gz"
    sha256 "5b7e96406c301a1366534479a7352ec40ec68bb327c0c119091635acd5925e35"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/30/21/093488dfc7cc8964ded15ab726fad40f25fd3d788fd741cc1c5a17d78ee8/zipp-3.23.1.tar.gz"
    sha256 "32120e378d32cd9714ad503c1d024619063ec28aad2248dc6672ad13edfa5110"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp -v 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)

    expected_plugins = %w[
      black
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end
