class Hatch < Formula
  include Language::Python::Virtualenv

  desc "Modern, extensible Python project management"
  homepage "https://hatch.pypa.io/latest"
  url "https://files.pythonhosted.org/packages/28/36/40c72b28fd33bfd6264efd417a544abb14ec1e5401a43b86431412e1ba6f/hatch-1.3.1.tar.gz"
  sha256 "fb1bdad4a22d3443137036b246898c5d3c7552ff4ba399b4605548cef0a22496"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58144c5237cbe803c7ccd897783b98900f207a7b2b08b35be040852a24a0296f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "110ff4e8bba1e600464ae0fdef54c8bb224e13ba63c21b887c17c280987382d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7e675d36dd524dd30177ecba9bc28aaa4923799718fa80e598bc577be1f08a32"
    sha256 cellar: :any_skip_relocation, big_sur:        "18984335924444a7fe600a979bbeb2058d1e154373d69d8b6cc1e49155feddd8"
    sha256 cellar: :any_skip_relocation, catalina:       "8a5c891650abd284e979fa94269fa0711c30a2a5edfd8cff7e4590a435ae203c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77306587b5e53955e006f3cadb8302447cf03edfad20daac3156c25736ec8341"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/67/c4/fd50bbb2fb72532a4b778562e28ba581da15067cfb2537dbd3a2e64689c1/anyio-3.6.1.tar.gz"
    sha256 "413adf95f93886e442aea925f3ee43baa5a765a64a0f52c6081894f9992fdd0b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "editables" do
    url "https://files.pythonhosted.org/packages/01/b0/a2a87db4b6cb8e7d57004b6836faa634e0747e3e39ded126cdbe5a33ba36/editables-0.3.tar.gz"
    sha256 "167524e377358ed1f1374e61c268f0d7a4bf7dbd046c656f7b410cde16161b1a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f3/c7/5c1aef87f1197d2134a096c0264890969213c9cbfb8a4102087e8d758b5c/filelock-3.7.1.tar.gz"
    sha256 "3a0fd85166ad9dbab54c9aec96737b744106dc5f15c0b09a6744a445299fcf04"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/83/2d/8fe45dabfdc8630999420fa9439f5dd8138f2a375a41a78f97dd2b7304dc/hatchling-1.5.0.tar.gz"
    sha256 "9ca409a41140cc662164680b78adcd3ba77b23a945984bd9970d11fe38e86a38"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/42/98/44c3e51a0655eae75adefee028c9bada7427a90f63105e54f5e735946f50/httpcore-0.15.0.tar.gz"
    sha256 "18b68ab86a3ccf3e7dc0f43598eaddcf472b602aba29f9aa6ab85fe2ada3980b"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/43/cd/677173d194b4839e5b196709e3819ffca2a4bc58b0538f4ae4be877ad480/httpx-0.23.0.tar.gz"
    sha256 "f28eac771ec9eb4866d3fb4ab65abd42d38c424739e80c08d8d20570de60b0ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a4/9e/9d9eb6a6dc4f347bae8200a2e1dd65a7b96ae99e29ef8f7452ccc4ef9eea/keyring-23.6.0.tar.gz"
    sha256 "3ac00c26e4c93739e19103091a9986a9f79665a78cf15a4df1dba7ea9ac8da2f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/bb/2d/c902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825/rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/1e/81/93889ea6641154b22f26036bc4ef800b06df84fc647a6ded5abdc2f06dcf/tomlkit-0.11.1.tar.gz"
    sha256 "61901f81ff4017951119cd0d1ed9b7af31c821d6845c8c477587bbdcd5e5854e"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/85/ee/820c8e5f0a5b4b27fdbf6f40d6c216b6919166780128b6714adf3c201644/userpath-1.8.0.tar.gz"
    sha256 "04233d2fcfe5cff911c1e4fb7189755640e1524ff87a4b82ab9d6b875fee5787"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/2f/05b77cb73501c01963de2cef343839f0803b64aab4d5476771ae303b97a6/virtualenv-20.15.1.tar.gz"
    sha256 "288171134a2ff3bfb1a2f54f119e77cd1b81c29fc1265a2356f3e8d14c7d58c4"
  end

  def install
    virtualenv_install_with_resources

    (zsh_completion/"_hatch").write Utils.safe_popen_read({ "_HATCH_COMPLETE" => "zsh_source" }, bin/"hatch")
    (fish_completion/"hatch.fish").write Utils.safe_popen_read({ "_HATCH_COMPLETE" => "fish_source" }, bin/"hatch")
  end

  test do
    system bin/"hatch", "new", "homebrew"
    assert_predicate testpath/"homebrew/pyproject.toml", :exist?

    cd testpath/"homebrew" do
      inreplace "pyproject.toml", "dependencies = []", "dependencies = ['requests==2.24.0']"
      system bin/"hatch", "config", "set", "dirs.env.virtual", ".venv"
      system bin/"hatch", "env", "create"
      output = shell_output("#{bin}/hatch env run -- python -c 'import requests;print(requests.__version__)'")
      assert_equal "2.24.0", output.strip
    end
  end
end
