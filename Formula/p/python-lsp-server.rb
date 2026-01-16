class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/b4/b5/b989d41c63390dfc2bf63275ab543b82fed076723d912055e77ccbae1422/python_lsp_server-1.14.0.tar.gz"
  sha256 "509c445fc667f41ffd3191cb7512a497bf7dd76c14ceb1ee2f6c13ebe71f9a6b"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5213350eaab550b1f401cf6da503956ee89382f2b77990f11ca74b857cd93f70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d224c9ee1db4e853a5e650dca9fec786b034269c7ecea10966b824ea40abc25b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6307022b817fef1cd99e9faf18dd46ca59623dcd738d1976aec6af2cdfec2d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "2643ead4d855f5b3e72521d6b62a8533f41d4b54aa853931bb67e7e380b92d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba967b3b0ecb553a9ebf283eebeb4ce1cf58fc892136887c5e14abcf544c2de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2086ceabd14f2f66c21e213da25e91f5a875a019608b260a84f2c35807a6c2f6"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages package_name:   "python-lsp-server[websockets]",
                extra_packages: %w[python-lsp-black pylsp-mypy python-lsp-ruff pylsp-rope]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/8c/ad/33adf4708633d047950ff2dfdea2e215d84ac50ef95aff14a614e4b6e9b2/black-25.11.0.tar.gz"
    sha256 "9a323ac32f5dc75ce7470501b887250be5005a01602e931a15e45593f70f6e08"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/6e/00/2432bb2d445b39b5407f0a90e01b9a271475eea7caf913d7a86bcb956385/cattrs-25.3.0.tar.gz"
    sha256 "1ac88d9e5eda10436c4517e390a4142d88638fe682c436c93db7ce4a277b884a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/d8/8abe80d62c5dce1075578031bcfde07e735bcf0afe2886dd48b470162ab4/docstring_to_markdown-0.17.tar.gz"
    sha256 "df72a112294c7492487c9da2451cae0faeee06e86008245c188c5761c9590ca3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/72/3a/79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17a/jedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "librt" do
    url "https://files.pythonhosted.org/packages/a4/1a/38eea84b96d964bf9756d16f20534c4442103345719f600b1b267233b7bb/librt-0.7.2.tar.gz"
    sha256 "48aa0f311bdf90ec9a63e3669b6aff04967f24f2f67fe9372c570a21dc9ae873"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/f9/b5/b58cdc25fadd424552804bf410855d52324183112aa004f0732c5f6324cf/mypy-1.19.0.tar.gz"
    sha256 "f6b874ca77f733222641e5c46e4711648c4037ea13646fd0cdc814c2eaec2528"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/d4/de/53e0bcf53d13e005bd8c92e7855142494f41171b34c2536b86187474184d/parso-0.8.5.tar.gz"
    sha256 "034d7354a9a018bdce352f48b2a8a450f05e9d6ee85db84764e9b6bd96dafe5a"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/e9/4d/9683a57f2e8b9263910ef497a99d88622f4fb1c158decb867fd40a41bfdd/pylsp_mypy-0.7.0.tar.gz"
    sha256 "e94f531d4ce523222c2af7471abe396cfeb4cc3c4b181d54462fb6d553e1e0b3"
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
    url "https://files.pythonhosted.org/packages/af/79/2f6322c47bd2956447e0a6787084b4110b4473e3d2501b86aa47c802e6a0/python_lsp_ruff-2.3.0.tar.gz"
    sha256 "647745b7f3010ac101e3c53a797b8f9deb1f52228b608d70ad0e8e056978c3b7"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/4e/8d/a762be14dae1c3bf280202ba3172020b2b0b4c537f94427435f19c413b72/pytokens-0.3.0.tar.gz"
    sha256 "2f932b14ed08de5fcf0b391ace2642f858f1394c0857202959000b68ed7a458a"
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
    url "https://files.pythonhosted.org/packages/ed/d9/f7a0c4b3a2bf2556cd5d99b05372c29980249ef71e8e32669ba77428c82c/ruff-0.14.8.tar.gz"
    sha256 "774ed0dd87d6ce925e3b8496feb3a00ac564bea52b9feb551ecd17e0a23d1eed"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/43/d9/3f17e3c5773fb4941c68d9a37a47b1a79c9649d6c56aefbed87cc409d18a/ujson-5.11.0.tar.gz"
    sha256 "e204ae6f909f099ba6b6b942131cee359ddda2b6e4ea39c12eb8b991fe2010e0"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
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
