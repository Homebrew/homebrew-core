class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/06/f4/38f315a1d8568257a74fe482e925368a2ef4bccc9b1d5751f003570bccc5/coconut-3.2.0.tar.gz"
  sha256 "0c64554deef3a35b2688368315cc2087dd8244e1b13d6b869fe5c2e679d6a0ad"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dccf150ed03aedc51fd8a10bbc9c4633cdd55187e0303e09c5c1fbe07ce121d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7440e8824b741645ab98713c2968538b90a7ce70057d702ac4e2a05cc491a881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60edb417688597b8616690ffb55c94beed1a37936bd5402bb52677623df5e9ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "6697f68b51123621d97fa2bc4f5c807c620ed3ecec41d334686dcbc15d2b5c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f57cfee3efeb87d561d5f3fffae7220effb19bf88f45c9dd5cad63dc608395b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e84fd40d69646e2d3d20926a2267d9c0b79d9e097e34899abeead71c8b4a552"
  end

  depends_on "python@3.14"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/a4/a4/b1519d785b1964ddde4bbb1a3675e5442c1af1dc4c6fe27d36adf54a97c4/cpyparsing-2.4.7.2.4.3.tar.gz"
    sha256 "e69499f9f84c89421ed642c0be5cb27e670a5b1b4eda6d21f64418d8baf13a38"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "tstr" do
    url "https://files.pythonhosted.org/packages/66/40/88e526174c65fe84552c5b920b0b7ec0787c52148106932cb72020561080/tstr-0.4.1.tar.gz"
    sha256 "bad326e07fe239eb4c63635964a6de9d55ff40ab223b04c6361b01c3b709523d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
