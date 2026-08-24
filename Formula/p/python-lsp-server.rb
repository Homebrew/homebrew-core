class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/e6/63/7d6af072a5b77a0d1f61306b7a72a7a2bc3f29ec0f8a8c85eb23f5ba7716/python_lsp_server-1.15.0.tar.gz"
  sha256 "85fa090262c3d1aef09b759d98811d6cb9ad5bbc58af15d588608ae8c1925801"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "77f9224701cc2726b82468010c7be759b42aa7046cbe66e4bf7375a9a04f4405"
    sha256 cellar: :any, arm64_sequoia: "0924c5c2065bf74fa6ad320205db5625c7b5c8819cb4bbff3417c20147bbab7d"
    sha256 cellar: :any, arm64_sonoma:  "e3a4936fb69c0cb780c63fb7150cda747cee0c964fe3e3cd1510c43b04851227"
    sha256 cellar: :any, sonoma:        "7274117aed79ee4bd4718fbc5268c774b28b4db74b4cb83322e3eaba80ba2bbe"
    sha256 cellar: :any, arm64_linux:   "d579a36049a67cd0db8fe06138f3d7ad6b262a9ec836db1f4beb4232aa354cac"
    sha256 cellar: :any, x86_64_linux:  "b3da653aea754e3e2b664c00283fb11f0cc21067e36faf24f8af7d7df335ddb9"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages package_name:   "python-lsp-server[websockets]",
                extra_packages: %w[python-lsp-black pylsp-mypy python-lsp-ruff pylsp-rope]

  resource "ast-serialize" do
    url "https://files.pythonhosted.org/packages/58/ad/0d70a3a2d6e01968d985415259e8ec7ad3f777903f9b1c1f3c8c44642c60/ast_serialize-0.6.0.tar.gz"
    sha256 "aadd3ffcf4858c9726bf3515f7b199c7eadbe504f96028e4a87172c0da65a8fe"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
    url "https://files.pythonhosted.org/packages/46/b7/a3635f6a2d7cf5b5dd98064fc1d5fbbafcb25477bcea204a3a92145d158b/jedi-0.20.0.tar.gz"
    sha256 "c3f4ccbd276696f4b19c54618d4fb18f9fc24b0aef02acf704b23f487daa1011"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/dc/2f/3908645ddddab7120b46295e541ead308109fa48dbec7d67d7a778870d60/librt-0.13.0.tar.gz"
    sha256 "1d2a610c14ac0d0750ee0a3ab8548e83155258387891caaca04def4bf7289781"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/12/af/4e516a05d3ca2eb9283e9ec45b2c02225c1514dd6da49fd3c9eaa6639370/mypy-2.3.0.tar.gz"
    sha256 "465965d41cd9a2726694e983e8ce7113259327bec798115d1e1dfa2a52fb666e"
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
    url "https://files.pythonhosted.org/packages/78/9b/560e4be8e26f6fd133a03630a8df0c663b9e8d61b4ade152b72005aec83b/platformdirs-4.11.0.tar.gz"
    sha256 "0555d18370482847566ffabcaa53ad7c6c1c29f195989ae1ed634a05f76ea1e0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/c2/d3/25f5fdecdeebee9f896b45011a03657bfd7b85503659ddee20e9a97bec7e/pylsp_mypy-0.8.0.tar.gz"
    sha256 "00d86eafa4e544ee81a73979eff1a998fbd40d4ae9c1821fe88023326a756dc2"
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
    url "https://files.pythonhosted.org/packages/4d/94/1e5e4967626faf12fa56999cd6222dff6992ceb086ad7945756baf70c7a7/ruff-0.16.0.tar.gz"
    sha256 "e460aafd5495ec89efaa6ced2e4a9a581116451e1c88b9d37ef497e0f8e93982"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/89/7a/c8bb37c8f6f3623d60c33d15d18cd6d6655d0f9c3eb31a9969f76361b199/ujson-5.13.0.tar.gz"
    sha256 "d62e3d7625384c08082abad81a077af587fdef2761bb14c3822f4234b8d07d75"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
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
