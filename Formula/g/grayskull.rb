class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/d4/28/103ed458290f40221e0eb4d8f8268e7fbdc6b4f5ccd49bef73f7ddd26f86/grayskull-2.5.0.tar.gz"
  sha256 "b021138655be550fd1b93b8db08b9c66169fac9cba6bcdad1411263e12fc703f"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab4458e6a8988248f9d1e8e45c642b5bd475b1e5510c1f4b001771691a920b50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e8d3b7c1c630747bccb78f06f759df9b99cfa57c66205699e66a61cdd36ef9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da54129589f43e6ab58979e57e3a05d7b70494d73e173edfc0713c8c1db6b93a"
    sha256 cellar: :any_skip_relocation, sonoma:         "999b0bfa66476ee23d70c3420073767e1cadc68c6c12e0853363965122d98527"
    sha256 cellar: :any_skip_relocation, ventura:        "95ca890de98cfdec8e28e93f419c5b5509d6f8cd64a0ad4a6df7633ee4554920"
    sha256 cellar: :any_skip_relocation, monterey:       "9d0983b473e63b099c3cf6b11b92c912a83cdcb29c837765eb91317b48dbe947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787c9fa6a6a35bff1594f0d02341dc5a953655b912555445989b5c52c8b476a5"
  end

  depends_on "cmake" => :build
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/7c/1b/c9f6ae95599a071500ff9c8ead4381ff8691362c272e567c12a1c5fe94b2/progressbar2-4.2.0.tar.gz"
    sha256 "1393922fcb64598944ad457569fbeb4b3ac189ef50b5adb9cef3284e87e394ce"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/9c/eb/0a867dd2d8b0c7e5974990e7eea097e560f9689df93d0aa7902e412a690f/python-utils-3.8.1.tar.gz"
    sha256 "ec3a672465efb6c673845a43afcfafaa23d2594c24324a40ec18a0c59478dc0b"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/1a/bc/1475cf5a75bcdfdf59b3947e9ffdfab3518629110a662c20d90b67ce037f/rapidfuzz-3.3.1.tar.gz"
    sha256 "6783b3852f15ed7567688e2e358757a7b4f38683a915ba5edc6c64f1a3f0b450"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "ruamel-yaml-jinja2" do
    url "https://files.pythonhosted.org/packages/91/e0/ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abff/ruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/46/30/a14b56e500e8eabf8c349edd0583d736b231e652b7dce776e85df11e9e0b/semver-3.0.1.tar.gz"
    sha256 "9ec78c5447883c67b97f98c3b6212796708191d22e4ad30f4570f840171cbce1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/1e/bb/47f17e319e28e13f7cacf50d397965e2429e5ba7e68424c605c74928d659/stdlib_list-0.9.0.tar.gz"
    sha256 "98eb66135976c96b4ee3f4c0ef0552ebb5a9977ce3028433db79f4738b02af26"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
