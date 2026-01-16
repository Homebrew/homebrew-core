class Pelican < Formula
  include Language::Python::Virtualenv

  desc "Static site generator that supports Markdown and reST syntax"
  homepage "https://getpelican.com/"
  url "https://files.pythonhosted.org/packages/cf/ab/a5e863de66054c561e111687b4c1f7cb2ad5f2d4805d2bb12863f0f637cd/pelican-4.11.0.post0.tar.gz"
  sha256 "0d5e9c0cc9c6713ab6c25b2c4b64844f34d9be8c8c8cc7f42c3a8aa6b3bbbe33"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e277d1a8e8d1625d447c9ef37653d430857521bc09b9de7a1807312f4607b68"
    sha256 cellar: :any,                 arm64_sequoia: "28e907ea9ee64065b5fdb510cbbe17b9c31b3c80208f5106d4acb208d99daeb9"
    sha256 cellar: :any,                 arm64_sonoma:  "34810c7215386ec3cb9324b0e27048e2e4d730458b67031d117eb5ea108aeb86"
    sha256 cellar: :any,                 sonoma:        "82afdff03fb2b0e88758d388eee5ff6ea171f5bc127550a9acfb734856fd9129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab92e94e5f5c2d8790df1a5cf7d923ef13d763094c731ae34d7e26fcef83f662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f7771d3e1183bb045c920f33d6531fe2020423a0d3c4e16ecbd0abb19501618"
  end

  depends_on "rust" => :build # for `watchfiles`
  depends_on "python@3.14"

  pypi_packages package_name: "pelican[markdown]"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
    sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
  end

  resource "feedgenerator" do
    url "https://files.pythonhosted.org/packages/b0/d2/f05e9f4628cb0df988de66f8a97dd52877490e6ebf8e7b41cd341bf2ad6b/feedgenerator-2.2.1.tar.gz"
    sha256 "0eaa955f1f0bcb5b87ac195af740f06ff9fff4a40ed30b8a7c6bbebb264d4dd1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/8d/37/02347f6d6d8279247a5837082ebc26fc0d5aaeaf75aa013fcbb433c777ab/markdown-3.9.tar.gz"
    sha256 "d2900fe1782bd33bdbbd56859defef70c2e78fc46668f8eb9df3128138f2cb6a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  end

  def install
    virtualenv_install_with_resources
    # Remove ARM binaries on Intel macOS
    rm_r libexec.glob("lib/python*.*/site-packages/pelican/build/aarch64-*") if OS.mac? && Hardware::CPU.intel?
  end

  test do
    (testpath/"content/test-article.md").write <<~MARKDOWN
      Title: Test Article
      Date: #{Time.now}
      Category: Test

      This is a test article
    MARKDOWN

    system bin/"pelican"
    assert_path_exists "output/test-article.html"
  end
end
