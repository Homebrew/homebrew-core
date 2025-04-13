class Animdl < Formula
  include Language::Python::Virtualenv

  desc "Anime downloader and streamer"
  # pin lxml and yarl once https://github.com/justfoolingaround/animdl/pull/308 merged and released
  homepage "https://github.com/justfoolingaround/animdl"
  url "https://files.pythonhosted.org/packages/5b/79/4be6ac2caca32dea6fe500e5f5df9d74a3a5ce1d500175c3a7b69500bb3f/animdl-1.7.27.tar.gz"
  sha256 "fd97b278da4c82da88759993eaf6d8ad6fc3660d0f03de5b2151279c4ebd8370"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/justfoolingaround/animdl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5aaa37e63ae5e8b1e9fb2fd0412373e8c5bcceb7eb79380ca0fc3f34b047f20c"
    sha256 cellar: :any,                 arm64_sonoma:  "efaaca845d0eecd8bf4bc5eb17c608b8e160981f435ece7ef7f1c2974e7ff014"
    sha256 cellar: :any,                 arm64_ventura: "9525f12cfd47300b58e2d8dd1fe726b5271e5efc88c7df3d5ad1d5ff8b7751e4"
    sha256 cellar: :any,                 sonoma:        "0f4968fcb2a2aad6e52bd1660a4397e9a4f07ae2fec2d3ca3bdc1dda09e9c82a"
    sha256 cellar: :any,                 ventura:       "f5d300f45f9da97629c76e70689d90ce818e328701774b1cb6cb034bb9a19518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f23fb533affd1c176c1e76f379d12127da98c7b6f084ec7819bc13527beac93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165920e2f9da447e3b0ef0877851af4f38b339c145fe2d27bcb7a1e57148e714"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anchor-kr" do
    url "https://files.pythonhosted.org/packages/dd/46/c96feb94c9101ca57b9d612b6510b06da31d31321e5c54fca6cb4a6a0adf/anchor-kr-0.1.3.tar.gz"
    sha256 "0fc055b6fd359bd20225dc4c39f721535af3245b068724db09c62a0f95ec4bbf"
  end

  resource "anitopy" do
    url "https://files.pythonhosted.org/packages/d3/8b/3da3f8ba73b8e4e5325a9ecbd6780f4dc9f41c98cc1c6a897800c4f85979/anitopy-2.1.1.tar.gz"
    sha256 "515b97cd78917ee406313f4eb53bdc75e8a573e6ad5252ffd355c96a06988e26"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "comtypes" do
    url "https://files.pythonhosted.org/packages/e9/c3/f1b3d86f210e42c3103d4e6c22b9775747d78c337acd3f7f7ab615f5c3e2/comtypes-1.1.14.zip"
    sha256 "5d7caf6d3a86d51ddfc53e4548cae2dceee1b46672f8bd59679711dd01a934f2"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/61/42/5c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2/httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f5/50/04d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72d/httpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/6f/c3/4f625ca754f4063200216658463a73106bf725dc27a66b84df35ebe7468c/pkginfo-1.11.2.tar.gz"
    sha256 "c6bc916b8298d159e31f2c216e35ee5b86da7da18874f879798d0a1983537c86"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/24/40/e249ac3845a2333ce50f1bb02299ffb766babdfe80ca9d31e0158ad06afd/pycryptodomex-3.14.1.tar.gz"
    sha256 "2ce76ed0081fd6ac8c74edc75b9d14eca2064173af79843c24fa62573263c1f2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/9a/50/672a8d347f92bc752b04c338bbf932fbd0104fbc416c82cc91aa5f7b4b0b/rich-13.3.3.tar.gz"
    sha256 "dc84400a9d842b3a9c5ff74addd8eb798d155f36c1c91303888e0a66850d2a15"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/04/e65e7f457ce9a2e338366a3a873ec6994e081cf4f99becb59ab6ce19e4b5/tqdm-4.65.2.tar.gz"
    sha256 "5f7d8b4ac76016ce9d51a7f0ea30d30984888d97c474fdc4a4148abfb5ee76aa"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/1e/87/6d71456eabebf614e0cac4387c27116a0bff9decf00a70c362fe7db9394e/yarl-1.9.11.tar.gz"
    sha256 "c7548a90cb72b67652e2cd6ae80e2683ee08fde663104528ac7df12d8ef271d2"
  end

  # Multiple resources are too old to build on recent Xcode/macOS,
  # can delete this after a change like this is merged and released in a new version:
  # https://github.com/justfoolingaround/animdl/pull/301
  # The patch isn't strictly needed but it's an easy way to see which Python `resource`
  # blocks needed to be manually bumped to newer versions.
  patch :DATA

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"animdl", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    test_config = testpath/"config.yml"
    test_config.write <<~YAML
      default_provider: animixplay
    YAML

    assert_match "One Piece Film", shell_output("#{bin}/animdl search \"one piece\" 2>&1")
    assert_match "animdl, version #{version}", shell_output("#{bin}/animdl --version")
  end
end
__END__
diff --git a/pyproject.toml b/pyproject.toml
index e0e8782..e71eacf 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -21,8 +21,8 @@ httpx = "~=0.23.0"
 tqdm = ">=4.62.3,<4.66.0"
 pycryptodomex = "~=3.14.1"
 regex = "~=2022.10.31"
-yarl = "~=1.8.1"
-pyyaml = "~=6.0"
+yarl = "~=1.9.11"
+pyyaml = "~=6.0.1"
 packaging = ">=22,<24"
 pkginfo = "^1.9.2"
 rich = ">=13.3.1,<13.3.4"
@@ -33,5 +33,5 @@ rich = ">=13.3.1,<13.3.4"
 animdl = "animdl.__main__:__animdl_cli__"

 [tool.poetry.dependencies.lxml]
-version = "4.9.1"
+version = "5.1.0"
 markers = "sys_platform != 'win32'"
