class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/d5/28/47137c83faf18a85d6782a099d4a6129097c20625d77c0bd75185296f493/grayskull-2.6.0.tar.gz"
  sha256 "39ec33a74b716c4e3ed876733669866f1b0743a242e16255e772e793598cb2dd"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfa638553ec5077b1ba2227beaff156ae082d562a86ea5efe756a2d0ec219abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4aee1203e48e5d4b369a483bc9f94c895a9b7f6dc9d87b315685157a99a02ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b86de0ec41d1721ae49d797ecf0e5f2f4d69f4527aa2a890f495709edf35dfab"
    sha256 cellar: :any_skip_relocation, sonoma:         "0042c715a7d69bdd04da2e38ed70296b3d56989df1417bf8e82f220ae8e34298"
    sha256 cellar: :any_skip_relocation, ventura:        "9005cea1d196a8fcda6d820bbcc5e142be0e46fb8606bb66f00c2dc48333bdea"
    sha256 cellar: :any_skip_relocation, monterey:       "21b31580b95b5df1c18006f93dc88d9980a4e91afe8dc2fcdc3cb1b95be04317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18c34a6ba0f05b97640877fc3dcf977b1d04db78c2c2c8002ebcc1365b07876"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/4f/a1/f00755330cb34bc19b1ba744b9880c51a9b1ed8526039354736d5f4dfb0d/pkginfo-1.11.1.tar.gz"
    sha256 "2e0dca1cf4c8e39644eed32408ea9966ee15e0d324c62ba899a393b3c6b467aa"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/41/7b/42c1cec1218b8b9289d6c84bc9d874df1f06db642ad3350d01a4116de834/progressbar2-4.4.2.tar.gz"
    sha256 "3fda2e0c60693600a6585a784c9d3bc4e1dac57e99e133f8c0f5c8cf3df374a2"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/a7/0c/587d2274217c13e9d1ba091560e9161ae94dd04053b390d70ef612b0af81/python-utils-3.8.2.tar.gz"
    sha256 "c5d161e4ca58ce3f8c540f035e018850b261a41e7cb98f6ccf8e1deb7174a1f1"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/50/b9/22b4848fc842b17c4446433d5d472007c9799dbe8dd90bc0f6d60767c29d/rapidfuzz-3.9.3.tar.gz"
    sha256 "b398ea66e8ed50451bce5997c430197d5e4b06ac4aa74602717f792d8d8d06e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
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
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/39/bb/1cdbc326a5ab0026602e0489cbf02357e78140253c4b57cd866d380eb355/stdlib_list-0.10.0.tar.gz"
    sha256 "6519c50d645513ed287657bfe856d527f277331540691ddeaf77b25459964a14"
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
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/grayskull --version").strip

    system bin/"grayskull", "pypi", "grayskull"
    assert_predicate testpath/"grayskull/meta.yaml", :exist?
  end
end
