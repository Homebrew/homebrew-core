class MetaPackageManager < Formula
  include Language::Python::Virtualenv

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/a0/94/b9dbfbf058f40ce3c64257806ae8ae76f377fc28f627b9b40777d26a742c/meta_package_manager-5.13.1.tar.gz"
  sha256 "364658a4c777725f6cccfe404c706ec514630eb15b5ac06a5a79cec6674b84ee"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ed10dce0a8da2dab64ade65994add7ed4c58253f3a074f9b98f342dc2a08921"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "003057beee036bdf14623e4f0c88bf25621ad17f815e65eddb6ba00ff497b0c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87f705d2fa66a2cada6cba27e92360c2e307405f5c545ed91eb6efb9bcac777e"
    sha256 cellar: :any_skip_relocation, sonoma:         "73d7652908ad0ad99ac28a719782290dad9a38de7e29b37714ce0a42adf18a7b"
    sha256 cellar: :any_skip_relocation, ventura:        "ecafeec7aff17331f65b8771ceae6473e14a574f49aff7b6535cbf07a286f3fc"
    sha256 cellar: :any_skip_relocation, monterey:       "91254e2e1bc3ae834c0187409b7883d99bd29442d73d2486db3a554096623a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53794ae1da403d7a988e282505af01cedcf44c93212a263128a01b3bb02f22b"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/94/71/a8ee96d1fd95ca04a0d2e2d9c4081dac4c2d2b12f7ddb899c8cb9bfd1532/alabaster-0.7.13.tar.gz"
    sha256 "a27a4a084d5e690e16e01e03ad2b2e552c61a65469419b907243193de1a84ae2"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/d5/7d/08e7b8b1ab446121ace3de332f144be41a52049a23303375a0126d515cb7/Babel-2.13.0.tar.gz"
    sha256 "04c3e2d28d2b7681644508f836be388ae49e0cfe91465095340395b60d00f210"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/e1/13/1a38fd4ee194985cfc674358fcf2ca10a80c5b14fafa62abbb1e6088fcab/boltons-23.0.0.tar.gz"
    sha256 "8c50a71829525835ca3c849c7ed2511610c972b4dddfcd41a4a5447222beb4b0"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/06/04/c7c0cb18120e8cb8629c975ae5e118e5b44b2c0cfaa63dc39b45d779e66f/click_extra-3.10.0.tar.gz"
    sha256 "74e7b65c453c6e2d59f87d63f8fa249ede4362851f4cf32f46e0953d472609d6"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/71/b6/2819a7290c0f5bf384be3f507f2cfbc0a93a8148053d0bde2040d2e09124/cloup-2.1.2.tar.gz"
    sha256 "43f10e944056f3a1eea714cb67373beebebbefc3f4551428750392f3e04ac964"
  end

  resource "commentjson" do
    url "https://files.pythonhosted.org/packages/c0/76/c4aa9e408dbacee3f4de8e6c5417e5f55de7e62fb5a50300e1233a2c9cb5/commentjson-0.9.0.tar.gz"
    sha256 "42f9f231d97d93aff3286a4dc0de39bfd91ae823d1d9eba9fa901fe0c7113dd4"
  end

  resource "furo" do
    url "https://files.pythonhosted.org/packages/d3/21/233938933f1629a4933c8fce2f803cc8fd211ca563ea4337cb44920bbbfa/furo-2023.3.27.tar.gz"
    sha256 "b99e7867a5cc833b2b34d7230631dd6558c7a29f93071fdbb5709634bb33c5a5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/a7/84/62473fb57d61e31fef6e36d64a179c8781605429fd927b5dd608c997be31/imagesize-1.4.1.tar.gz"
    sha256 "69150444affb9cb0d5cc5a92b3676f0b2fb7cd9ae39e947a5e11a36b4497cd4a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lark-parser" do
    url "https://files.pythonhosted.org/packages/34/b8/aa7d6cf2d5efdd2fcd85cf39b33584fe12a0f7086ed451176ceb7fb510eb/lark-parser-0.7.8.tar.gz"
    sha256 "26215ebb157e6fb2ee74319aa4445b9f3b7e456e26be215ce19fdaaa901c20a4"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/33/34/a7843f732e1e0b01e961f6ae835b3fd6bd4e361c1a3a72debd31244cb718/packageurl-python-0.11.2.tar.gz"
    sha256 "01fbf74a41ef85cf413f1ede529a1411f658bda66ed22d45d27280ad9ceba471"
  end

  resource "pallets-sphinx-themes" do
    url "https://files.pythonhosted.org/packages/d2/33/95be76c25ed7b853f61cd7afbb5a2c1e17cca5fb39ca3f0f485a6d206358/Pallets-Sphinx-Themes-2.1.1.tar.gz"
    sha256 "e5da65967bb6fae3055682a97d37c3311fe38e132c0761052c16aaacafc8d47f"
  end

  resource "pygments-ansi-color" do
    url "https://files.pythonhosted.org/packages/b2/93/af2feb6f3f436a44fbe20c0b6861641ad01f00139d96ae27a2649149bad3/pygments-ansi-color-0.2.0.tar.gz"
    sha256 "8e2f9a57873b4b28d6b95a8f1c9f346be5fc0f9e4f4a316594584a0684aa7959"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "sphinx" do
    url "https://files.pythonhosted.org/packages/af/b2/02a43597980903483fe5eb081ee8e0ba2bb62ea43a70499484343795f3bf/Sphinx-5.3.0.tar.gz"
    sha256 "51026de0a9ff9fc13c05d74913ad66047e104f56a129ff73e174eb5c3ee794b5"
  end

  resource "sphinx-basic-ng" do
    url "https://files.pythonhosted.org/packages/98/0b/a866924ded68efec7a1759587a4e478aec7559d8165fac8b2ad1c0e774d6/sphinx_basic_ng-1.0.0b2.tar.gz"
    sha256 "9ec55a47c90c8c002b5960c57492ec3021f5193cb26cebc2dc4ea226848651c9"
  end

  resource "sphinxcontrib-applehelp" do
    url "https://files.pythonhosted.org/packages/1c/5a/fce19be5d4db26edc853a0c34832b39db7b769b7689da027529767b0aa98/sphinxcontrib_applehelp-1.0.7.tar.gz"
    sha256 "39fdc8d762d33b01a7d8f026a3b7d71563ea3b72787d5f00ad8465bd9d6dfbfa"
  end

  resource "sphinxcontrib-devhelp" do
    url "https://files.pythonhosted.org/packages/2e/f2/6425b6db37e7c2254ad661c90a871061a078beaddaf9f15a00ba9c3a1529/sphinxcontrib_devhelp-1.0.5.tar.gz"
    sha256 "63b41e0d38207ca40ebbeabcf4d8e51f76c03e78cd61abe118cf4435c73d4212"
  end

  resource "sphinxcontrib-htmlhelp" do
    url "https://files.pythonhosted.org/packages/fd/2d/abf5cd4cc1d5cd9842748b15a28295e4c4a927facfa8a0e173bd3f151bc5/sphinxcontrib_htmlhelp-2.0.4.tar.gz"
    sha256 "6c26a118a05b76000738429b724a0568dbde5b72391a688577da08f11891092a"
  end

  resource "sphinxcontrib-jsmath" do
    url "https://files.pythonhosted.org/packages/b2/e8/9ed3830aeed71f17c026a07a5097edcf44b692850ef215b161b8ad875729/sphinxcontrib-jsmath-1.0.1.tar.gz"
    sha256 "a9925e4a4587247ed2191a22df5f6970656cb8ca2bd6284309578f2153e0c4b8"
  end

  resource "sphinxcontrib-qthelp" do
    url "https://files.pythonhosted.org/packages/4f/a2/53129fc967ac8402d5e4e83e23c959c3f7a07362ec154bdb2e197d8cc270/sphinxcontrib_qthelp-1.0.6.tar.gz"
    sha256 "62b9d1a186ab7f5ee3356d906f648cacb7a6bdb94d201ee7adf26db55092982d"
  end

  resource "sphinxcontrib-serializinghtml" do
    url "https://files.pythonhosted.org/packages/5c/41/df4cd017e8234ded544228f60f74fac1fe1c75bdb1e87b33a83c91a10530/sphinxcontrib_serializinghtml-1.1.9.tar.gz"
    sha256 "0c64ff898339e1fac29abd2bf5f11078f3ec413cfe9c046d3120d7ca65530b54"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/92/51/72ce10501dbfe508808fd6a637d0a35d1b723a5e8c470f3d6e9458a4f415/wcmatch-8.5.tar.gz"
    sha256 "86c17572d0f75cbf3bcb1a18f3bf2f9e72b39a9c08c9b4a74e991e1882a8efb3"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Check mpm is reporting the correct version of itself.
    assert_match "mpm, version #{version}", shell_output("#{bin}/mpm --version")
    # Check mpm is reporting its usage in help screen.
    assert_match "Usage: mpm [OPTIONS] COMMAND [ARGS]...", shell_output("#{bin}/mpm --help")
    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match(
      /\e\[32mbrew\e\[0m,Homebrew Formulae,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+,\e\[32m✓\e\[0m,\e\[32m✓\e\[0m \S+/,
      shell_output("#{bin}/mpm --output-format csv --all-managers managers"),
    )
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --output-format csv installed")
  end
end
