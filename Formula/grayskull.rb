class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/71/93/27ffbfcb57281a6051d738d9c8c35f9748a8b3c1f406249160006fa3aca2/grayskull-2.3.1.tar.gz"
  sha256 "41dd1cc94c8b8951571af7628ffa97146ae76e99295918a20d8db84b2f60b5e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa4b15a7c076ba19ecb914ba7b17a3b76a0c7bc64c911ae9f80336110d9e7e95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c95acad3d33106193b5b6b565af1886045085e13713d22898fdf36df629527d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d4907fb61496e0a532f024521bacb1127415bbe47f77c3e6d0a8c7f101bc07"
    sha256 cellar: :any_skip_relocation, ventura:        "a3dcef4fc5ae0ceade7d53acc51e330b9c03c71288b1db9df1961304b082ce5c"
    sha256 cellar: :any_skip_relocation, monterey:       "40d326fcd6471551b4e6854a8f2531b3c384261d2055f6dc90133745bfc3f3b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cd195904cd6de2801bdc2466c2991ae441f210d0fea131c2e6f89cf7ef0d69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4afcead349e23979bd0a8dab93c5e5b47fa1e6d2ea0ceab915eaee14a34294"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "conda-souschef" do
    url "https://files.pythonhosted.org/packages/78/6a/c4d067f8ef39b058a9bd03018093e97f69b7b447b4e1c8bd45439a33155d/conda-souschef-2.2.3.tar.gz"
    sha256 "9bf3dba0676bc97616636b80ad4a75cd90582252d11c86ed9d3456afb939c0c3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/7c/1b/c9f6ae95599a071500ff9c8ead4381ff8691362c272e567c12a1c5fe94b2/progressbar2-4.2.0.tar.gz"
    sha256 "1393922fcb64598944ad457569fbeb4b3ac189ef50b5adb9cef3284e87e394ce"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/b5/58/6960ee22450cd006375c5f36f15acf7e82688d25c091efba05362d682b9e/python-utils-3.5.2.tar.gz"
    sha256 "68198854fc276bc4b2403b261703c218e01ef564dcb072a7096ed9ea7aa5130c"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/70/05/4030a8a7aa42d3e40ba7abf902de8e7e94ddcb61abda23f6a3ec5daf36df/rapidfuzz-3.0.0.tar.gz"
    sha256 "4c1d895d16f62e9ac88d303eb918d90a390bd712055c849e01c558b7ae0fa908"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/8c/4e/faa94211c1cc468cfa38990955181c52be9a249008f37751d8406ff4d9d9/ruamel.yaml-0.17.28.tar.gz"
    sha256 "3bf6df1c481d2463a633be6ee86e8aece941bb3298a9a0cd6d0865f47b1ddce6"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "ruamel-yaml-jinja2" do
    url "https://files.pythonhosted.org/packages/91/e0/ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abff/ruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/9f/93/b7389cdd7e573e70cfbeb4b0bbe101af1050a6681342f5d2bc6f1bf2d150/semver-3.0.0.tar.gz"
    sha256 "94df43924c4521ec7d307fc86da1531db6c2c33d9d5cdc3e64cca0eb68569269"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/bb/01/237cea071fd305f162ebbe1db18a59b56b0b5fdff19533c9a1beea0bdee7/stdlib-list-0.8.0.tar.gz"
    sha256 "a1e503719720d71e2ed70ed809b385c60cd3fb555ba7ec046b96360d30b16d9f"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/grayskull --version").strip

    system "#{bin}/grayskull", "pypi", "grayskull"
    assert_predicate testpath/"grayskull/meta.yaml", :exist?
  end
end
