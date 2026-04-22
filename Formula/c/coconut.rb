class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/06/f4/38f315a1d8568257a74fe482e925368a2ef4bccc9b1d5751f003570bccc5/coconut-3.2.0.tar.gz"
  sha256 "0c64554deef3a35b2688368315cc2087dd8244e1b13d6b869fe5c2e679d6a0ad"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed3bd6a6609bb93b250e8f94c79f311317d24daf04509d8d05446644677e154d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ea40addef43ca33ae546be6fef68da1893f8a5850c6cdce3d77f093380d1aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9929dd86b856a3019b6e5b1402deaad047f0a0989bfb18bb932426ddc5d8410"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf0244c6e386011453f1bf6c2152f1df4a80ae2667fa6b64dc94cf16ab3a51e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8760d1bf9d50f785aafd66f22e3596c6d4895cd61e5e3ecc7808a73dabb6167f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280288ae5802aaa463e0a583230ccd0a2cb5c6ada572189bf22cd95381f67a6f"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/bc/03/03144b7a0ff44105f88469aba140ddaabda870d4d3fa71e403953a020544/tstr-0.4.0.post1.tar.gz"
    sha256 "b1a977868e909eaf1fb03b31cb79809389c3195164f03fca08b6eb17824db209"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
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
