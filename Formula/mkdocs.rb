class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "https://www.mkdocs.org/"
  url "https://files.pythonhosted.org/packages/78/a3/ec98a4eab53b7adf435df6c17765e1d7b603e1487ad6ab7c824d5488bf5c/mkdocs-1.1.2.tar.gz"
  sha256 "f0b61e5402b99d7789efa032c7a74c90a20220a9c81749da06dbfbcbd52ffb39"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c632678896672c74e404e891f8ed7c94fbbef5d73c38397f0f77398ea98d8162" => :big_sur
    sha256 "83bca122681942a19f62221116cccb1f86bda80fcac623b6a6e9c30deb841998" => :arm64_big_sur
    sha256 "13c230e5bf220b7263cbf1313da9cf65bae3c00e3be2539578393ace54aa9b28" => :catalina
    sha256 "638c33971c1a7ee2c005e7904ed055b6ed73cc93fadab1366192a6e909bafe0c" => :mojave
    sha256 "98ef5fb680e42e9ac1e49a27c4583959496f68df2be46f61ed33752ff27fae87" => :high_sierra
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/4e/ab/5d6bc3b697154018ef196f5b17d958fac3854e2efbc39ea07a284d4a6a9b/click-7.1.1.tar.gz"
    sha256 "8a18b4ea89d8820c5d0c7da8a64b2c324b4dabb695804dbfea19b9be9d88c0cc"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "livereload" do
    url "https://files.pythonhosted.org/packages/27/26/85ba3851d2e4905be7d2d41082adca833182bb1d7de9dfc7f623383d36e1/livereload-2.6.1.tar.gz"
    sha256 "89254f78d7529d7ea0a3417d224c34287ebfe266b05e67e51facaf82c27f0f66"
  end

  resource "lunr" do
    url "https://files.pythonhosted.org/packages/ad/c0/431b92d6707a4bf7692ea76bcfb00aa0f1db737cd3daf4b4f6a85e2b9d6c/lunr-0.5.8.tar.gz"
    sha256 "c4fb063b98eff775dd638b3df380008ae85e6cb1d1a24d1cd81a10ef6391c26e"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/98/79/ce6984767cb9478e6818bd0994283db55c423d733cc62a88a3ffb8581e11/Markdown-3.2.1.tar.gz"
    sha256 "90fee683eeabe1a92e149f7ba74e5ccdc81cd397bd6c516d93a8da0ef90b6902"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/f6/1d/d925cfb4f324ede997f6d47bea4d9babba51b49e87a767c170b77005889d/nltk-3.4.5.zip"
    sha256 "bed45551259aa2101381bbdd5df37d44ca2669c5c3dad72439fa459b29137d94"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/95/84/119a46d494f008969bf0c775cb2c6b3579d3c4cc1bb1b41a022aa93ee242/tornado-6.0.4.tar.gz"
    sha256 "0fe2d45ba43b00a41cd73f8be321a44936dc1aba233dee979f17a042b83eb6dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~EOS
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~EOS
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end
