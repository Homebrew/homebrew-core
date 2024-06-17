class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/5e/58/835ce6e458317324a6c8a1fdd273659bd508d4c7967adca520e3d0b587f6/python-lsp-server-1.11.0.tar.gz"
  sha256 "89edd6fb3f7852e4bf5a3d1d95ea41484d1a28fa94b6e3cbff12b9db123b8e86"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a9088a51a98ffe60c0b897bc9a2586356f47bcb3ef17bac31da96f5fdc0e7d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "845e8df4be0afd85769c324c53212b5f412a3b2056a0202150b635355ce3895b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2beb6454694df1787e349936ab712a4efc92afcb0924207c6de52537ea45a676"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cda1798bb557b958f4c6a99667e98837045f7a89d05d3eb7a544ac33c297538"
    sha256 cellar: :any_skip_relocation, ventura:        "57320d3d8507af11249be18e9398a7a0c350ea1c77e21ca864f0cf8f6d90ac98"
    sha256 cellar: :any_skip_relocation, monterey:       "6c48af45224af2b3d1e2a52051abf8f7c96d106590d6888268844ed95a0de5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3e1544aa97b9c4158f7916e71adc2872b13a799e9db4115febaf3b07ada084f"
  end

  depends_on "rust" => :build
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/8f/5f/bac24a952668c7482cfdb4ebf91ba57a796c9da8829363a772040c1a3312/black-24.3.0.tar.gz"
    sha256 "a0c9c4a0771afc6919578cec71ce82a3e31e054904e7197deacbc9382671c41f"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/7a/ad/6a66abd14676619bd56f6b924c96321a2e2d7d86558841d94a30023eec53/docstring-to-markdown-0.15.tar.gz"
    sha256 "e146114d9c50c181b1d25505054a8d0f7a476837f0da2c19f07e06eaed52b73d"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/72/1e/a587a862c766a755a58b62d8c00aed11b74a15dc415c1bf5da7b607b0efd/mypy-1.9.0.tar.gz"
    sha256 "3cc5da0127e6a478cddd906068496a97a7618a21ce9b54bde5bf7e539c7af974"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/76/98/41e7fe44f2e9773bbf711ecc73c34a29b645ea6e454b36e723595d4ad4a4/pylsp-mypy-0.6.8.tar.gz"
    sha256 "3f8307ca07d7e253e50e38c5fe31c371ceace0bc33d31c3429fa035d6d41bd5f"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/5e/4b/2bbf498ebc1fa764f15c9155c0ed28900268ac22ddcb1d8cf219937bf151/pylsp-rope-0.1.16.tar.gz"
    sha256 "d680b688c60a40257a8842ec808a6e0de1596a47a5300f22aecfdc69555020a7"
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
    url "https://files.pythonhosted.org/packages/ae/8e/623702d362010dee2c45799242d5b42a54489552458ee5a4ad394632ecda/python-lsp-ruff-2.2.0.tar.gz"
    sha256 "67c14067f76bc3d16bd5473a574e0d7b3bd422d723b62d2b2a83356e8af051db"
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/18/dc/abf70d2c2bcac20e8c71a7cdf6d44e4ddba4edf65acb179248d554d743db/pytoolconfig-1.3.1.tar.gz"
    sha256 "51e6bd1a6f108238ae6aab6a65e5eed5e75d456be1c2bf29b04e5c1e7d7adbae"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/1c/c1/875e0270ac39b764fcb16c2dfece14a42747dbd0f181ac3864bff3126af1/rope-1.13.0.tar.gz"
    sha256 "51437d2decc8806cd5e9dd1fd9c1306a6d9075ecaf78d191af85fc1dfface880"
  end

  resource "ruff" do
    url "https://files.pythonhosted.org/packages/a0/98/91e1ad8a6777c300b15cad46a1b507375010f8a53cfeaa17f0385bde1103/ruff-0.3.4.tar.gz"
    sha256 "f0f4484c6541a99862b693e13a151435a279b271cff20e37101116a21e2a1ad1"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/54/6f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619e/ujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
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
