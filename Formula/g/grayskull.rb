class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/71/93/27ffbfcb57281a6051d738d9c8c35f9748a8b3c1f406249160006fa3aca2/grayskull-2.3.1.tar.gz"
  sha256 "41dd1cc94c8b8951571af7628ffa97146ae76e99295918a20d8db84b2f60b5e7"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "084de10e02d28a61c073f2a34aa069f26326f793f8d7c6504b3d8a8d13428b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b75b6708e0d66c8b01669964a9771c91230368e7a7b0b7f0898a8dd3523fb7a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d092faf329c325ea88ce9d954bc863336780751565b797a49698023d9e88a057"
    sha256 cellar: :any_skip_relocation, ventura:        "0dc14938bebad6e3cc9d32d56477a6452eca63725d42bef7e6ccbfe36beedbcc"
    sha256 cellar: :any_skip_relocation, monterey:       "a38cab62b6bca78908576b16b46ddd0c11c7207a27dfd53596b89aa68997e867"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d9136a0efad99188e96883172cd5f47e78f0d3510488efe64c6f9de7d6c67c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7802c6740e6b3d92c299f6edf4e7d8739080cdff3c42f0e6355cf3a92c05ea22"
  end

  depends_on "cmake" => :build
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/a7/5b/96bf5a5ce622b3894af79f3849d696389ab3a28a566a0df21cfa8e5a1903/python-utils-3.7.0.tar.gz"
    sha256 "1970468fff1c0adbd60b9a751e6a786223a9f0373c954571912d9cf4be49b552"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/29/73/b41cac4dcb1c8fde87fe6f1ce6e4e08de688305d48b99e8bfbba2654a57b/rapidfuzz-3.1.2.tar.gz"
    sha256 "1b1b2eab728efc239c8aab97b4821f8e10dcd5a1b066365d0e38023e3b2289e8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
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
    url "https://files.pythonhosted.org/packages/46/30/a14b56e500e8eabf8c349edd0583d736b231e652b7dce776e85df11e9e0b/semver-3.0.1.tar.gz"
    sha256 "9ec78c5447883c67b97f98c3b6212796708191d22e4ad30f4570f840171cbce1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/3c/8b/0111dd7d6c1478bf83baa1cab85c686426c7a6274119aceb2bd9d35395ad/typing_extensions-4.7.1.tar.gz"
    sha256 "b75ddc264f0ba5615db7ba217daeb99701ad295353c45f9e95963337ceeeffb2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
