class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/06/f4/38f315a1d8568257a74fe482e925368a2ef4bccc9b1d5751f003570bccc5/coconut-3.2.0.tar.gz"
  sha256 "0c64554deef3a35b2688368315cc2087dd8244e1b13d6b869fe5c2e679d6a0ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "040ca85e616756590d1bc5e3f0f8c083bc9c9c9968202f9a6821b290dd5ac46b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ae0c9fa05684caa4310454a077bdf5a76638bb80d0583ab106f9f46bdd04ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62ac6e9687c695468cd21215194fbcbf34ff28dcee0aaa022f49eb7046ef684"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bb30bc217e0ef036a3fbe12e345450a1d8e9e79bf46c05129807beff7e3e264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c02250bddf8b7ce6c06e1117ff7d67d4ef0fe7f5c4eaa8bd0526ec7c96195c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f73d968aa3e8f182260d25a640d9424e63609ba5ebda21822db8d7c949f6732"
  end

  depends_on "python@3.14"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/16/ce/8a777047513153587e5434fd752e89334ac33e379aa3497db860eeb60377/anyio-4.12.0.tar.gz"
    sha256 "73c693b567b0c55130c104d0b43a9baf3aa6a31fc6110116509f27bf75e21ec0"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/d6/f8/76a0f8c9b16d7d4ac21a409a2d0e532095ff17217d4876d70f3be3f1297f/cpyparsing-2.4.7.2.4.1.tar.gz"
    sha256 "d917f01a74b3fc614f939eb99fc328a08c9b1de58095660c0f29597744bf1d30"
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
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
