class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/95/9f/ace91b84daf25219c9b902b492683a245afb9b697210fe6be0653bf1ef14/grayskull-2.7.3.tar.gz"
  sha256 "9396245439584b92d656fdefb03d6911b5987f91a5ae714772ddcb338768cbb9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f97d34e43834d353d4b143514ec60313f8b23101948fc30ecb99f7960b55b817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcc3e796f28fabc581bcbd956211d20bc0f57c6eff3d9fd6001be4eb595b606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eb83c32eac8da2cf4030cac9d2c5436f7ebb1b66236da379f67e1dd87335b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "691848c1e050ef49f89ff3aba57ee0419ef6883d2f060f08fbdcf5013c3ca481"
    sha256 cellar: :any_skip_relocation, ventura:       "859659d75f409c334010f1004c80caf84950c8411a34ad34f08aafa015475da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac73929ac5924499431e0a843706b593e766b71534029ec6b3d6face289951a"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/6f/c3/4f625ca754f4063200216658463a73106bf725dc27a66b84df35ebe7468c/pkginfo-1.11.2.tar.gz"
    sha256 "c6bc916b8298d159e31f2c216e35ee5b86da7da18874f879798d0a1983537c86"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/19/24/3587e795fc590611434e4bcb9fbe0c3dddb5754ce1a20edfd86c587c0004/progressbar2-4.5.0.tar.gz"
    sha256 "6662cb624886ed31eb94daf61e27583b5144ebc7383a17bae076f8f4f59088fb"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/33/99/fd1e3f80357dd88378281013ae7040a443de395bb0855bf17cbb828488d1/python_utils-3.9.0.tar.gz"
    sha256 "3689556884e3ae53aec5a4c9f17b36e752a3e93a7ba2768c6553fc4dd6fa70ef"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/81/43/ce16df67029b8e4f528fd1b3fbe5e9fcfc6fcc16823c66349260dd93750e/rapidfuzz-3.10.0.tar.gz"
    sha256 "6b62af27e65bb39276a66533655a2fa3c60a487b03935721c45b7809527979be"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
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
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/39/bb/1cdbc326a5ab0026602e0489cbf02357e78140253c4b57cd866d380eb355/stdlib_list-0.10.0.tar.gz"
    sha256 "6519c50d645513ed287657bfe856d527f277331540691ddeaf77b25459964a14"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/35/b9/de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264b/tomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/d4/19/b65f1a088ee23e37cdea415b357843eca8b1422a7b11a9eee6e35d4ec273/tomli_w-1.1.0.tar.gz"
    sha256 "49e847a3a304d516a169a601184932ef0f6b61623fe680f836a2aa7128ed0d33"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/grayskull --version").strip

    system bin/"grayskull", "pypi", "grayskull"
    assert_predicate testpath/"grayskull/meta.yaml", :exist?
  end
end
