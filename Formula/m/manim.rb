class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/52/79/29f287beebcf52464c2cfd88015720992515062dd373bd37c2ed34955cdd/manim-0.19.0.tar.gz"
  sha256 "748115ffc1dea24940fd6d7a3edcae0ccedc3e1874ebc1f5d7e5c6d69a4f4505"
  license "MIT"
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "8c517c3d6e5def8042425feca0fc3c8d852add9dd46a0bd8d427cf3cac94a0bc"
    sha256 cellar: :any,                 arm64_sonoma:  "4f8370db3e6065598e34cdac7adbaa2ec88e0412d27fd9f611da98e9d4d1ede4"
    sha256 cellar: :any,                 arm64_ventura: "174f15caedad96eb8935b37d341b585ccfa9b23b3631c5b0dd0dfff821669415"
    sha256 cellar: :any,                 sonoma:        "0a63a760d4168ca845b6ab46c4fb77cd9ec34875f7ff2918c045db346e71fb85"
    sha256 cellar: :any,                 ventura:       "fcc74db970f3180f72b03fe9efa8d851d07a2dac5c563f9f6ca3e19ea9dbc098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ebd1a635a7a0866d712e04b969ee7fd2530106141dfb1d7ba5c8cf463dabe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc102d405ebabc301afdd44e8167a51373db4b1e7ca898e8617a89d694deef46"
  end

  depends_on "cmake" => :build # for mapbox_earcut
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "numpy"
  depends_on "pango"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "python@3.13"
  depends_on "scipy"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  resource "audioop-lts" do
    url "https://files.pythonhosted.org/packages/dd/3b/69ff8a885e4c1c42014c2765275c4bd91fe7bc9847e9d8543dbcbb09f820/audioop_lts-0.2.1.tar.gz"
    sha256 "e81268da0baa880431b68b1308ab7257eb33f356e57a5f9b1f915dfb13dd1387"
  end

  resource "av" do
    url "https://files.pythonhosted.org/packages/0c/9d/486d31e76784cc0ad943f420c5e05867263b32b37e2f4b0f7f22fdc1ca3a/av-13.1.0.tar.gz"
    sha256 "d3da736c55847d8596eb8c26c60e036f193001db3bc5c10da8665622d906c17e"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/d8/e4/0c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6b/beautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/86/c9/3c621e0b7898403556e807244104095df1132a6094384f80c272bba4e4e4/cloup-3.0.7.tar.gz"
    sha256 "c852e0a0541aa433c6ab31a9b8b503f63d9881e91ddaf0384d6927965f2b421c"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/18/40/7b17cd866158238db704965da1b5849af261dbad393ea3ac966f934b2d39/cython-3.1.2.tar.gz"
    sha256 "6bbf7a953fa6762dfecdec015e3b054ba51c0121a45ad851fa130f63f5331381"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "glcontext" do
    url "https://files.pythonhosted.org/packages/3a/80/8238a0e6e972292061176141c1028b5e670aa8c94cf4c2f819bd730d314e/glcontext-3.0.0.tar.gz"
    sha256 "57168edcd38df2fc0d70c318edf6f7e59091fba1cd3dadb289d0aa50449211ef"
  end

  resource "isosurfaces" do
    url "https://files.pythonhosted.org/packages/da/cf/bd7e70bb7b8dfd77afdc79aba8d83afd4a9263f045861cd4ddd34b7f6a12/isosurfaces-0.1.2.tar.gz"
    sha256 "fa51ebe864ea9355b26830e27fdd6a41d5a58b419fa8d4b47e3b8b80718d6e21"
  end

  resource "manimpango" do
    url "https://files.pythonhosted.org/packages/2a/8e/7f7a49d4bbe2c6dbef4a82c58e15fc5a35eedcf97a8f7c67ce5fa9a8c827/manimpango-0.6.0.tar.gz"
    sha256 "d959708e5c05e87317b37df5f6c5258aa9d1ed694a0b25b19d6a4f861841e191"
  end

  resource "mapbox-earcut" do
    url "https://files.pythonhosted.org/packages/8d/70/0a322197c1178f47941e5e6e13b0a4adeaaa7c465c18e3b4ead3eba49860/mapbox_earcut-1.0.3.tar.gz"
    sha256 "b6bac5d519d9947a6321a699c15d58e0b5740da61b9210ed229e05ad207c1c04"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "moderngl" do
    url "https://files.pythonhosted.org/packages/da/52/540e2f8c45060bb2709f56eb5a44ae828dfcc97ccecb342c1a7deb467889/moderngl-5.12.0.tar.gz"
    sha256 "52936a98ccb2f2e1d6e3cb18528b2919f6831e7e3f924e788b5873badce5129b"
  end

  resource "moderngl-window" do
    url "https://files.pythonhosted.org/packages/90/02/92e235891300c901f59647112a0267a07454f58aeb2041aa44f6b85f9cb3/moderngl_window-3.1.1.tar.gz"
    sha256 "29c2827505f87399f3461d480b2778910fddeebe44ea803301215cf212a6c1bc"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "pycairo" do
    url "https://files.pythonhosted.org/packages/40/d9/412da520de9052b7e80bfc810ec10f5cb3dbfa4aa3e23c2820dc61cdb3d0/pycairo-1.28.0.tar.gz"
    sha256 "26ec5c6126781eb167089a123919f87baa2740da2cca9098be8b3a6b91cc5fbc"
  end

  resource "pydub" do
    url "https://files.pythonhosted.org/packages/fe/9a/e6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fd/pydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyglet" do
    url "https://files.pythonhosted.org/packages/f7/bc/0533ccb30566ee59b540d700dbbf916dafa89132a4d582d0fd1fe158243d/pyglet-2.1.6.tar.gz"
    sha256 "18483880b1411b39692eaf7756819285797b1aaf9ef63d40eb9f9b5d01c63416"
  end

  resource "pyglm" do
    url "https://files.pythonhosted.org/packages/e1/19/9e9871a2cc8b3c26e57525a3233a5d75c4198c6cc7d63b62059b805fe531/pyglm-2.8.2.tar.gz"
    sha256 "b4847b0b60888b5c649b17b0a72d1f3f1ee07086cd5f431a7d977fad3cdbadab"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/e8/e9/0b85c81e2b441267bca707b5d89f56c2f02578ef8f3eafddf0e0c0b8848c/pyobjc_core-11.1.tar.gz"
    sha256 "b63d4d90c5df7e762f34739b39cc55bc63dbcf9fb2fb3f2671e528488c7a87fe"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/4b/c5/7a866d24bc026f79239b74d05e2cf3088b03263da66d53d1b4cf5207f5ae/pyobjc_framework_cocoa-11.1.tar.gz"
    sha256 "87df76b9b73e7ca699a828ff112564b59251bb9bbe72e610e670a4dc9940d038"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "screeninfo" do
    url "https://files.pythonhosted.org/packages/ec/bb/e69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27/screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "skia-pathops" do
    url "https://files.pythonhosted.org/packages/e5/85/4c6ce1f1f3e8d3888165f2830adcf340922416c155647b12ebac2dcc423e/skia_pathops-0.8.0.post2.zip"
    sha256 "9e252cdeb6c4d162e82986d31dbd89c675d1677cb8019c2e13e6295d4a557269"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3f/f4/4a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19f/soupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/66/b7/4a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030/srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "svgelements" do
    url "https://files.pythonhosted.org/packages/5d/29/1c93c94a2289675ba2ff898612f9c9a03f46d69f253bdf4da0dfc08a599d/svgelements-1.9.6.tar.gz"
    sha256 "7c02ad6404cd3d1771fd50e40fbfc0550b0893933466f86a6eb815f3ba3f37f7"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"

      # needed for pyobjc-core "-fdisable-block-signature-string"
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699
    else
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(bin/"manim", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"testscene.py").write <<~PYTHON
      from manim import *

      class CreateCircle(Scene):
          def construct(self):
              circle = Circle()  # create a circle
              circle.set_fill(PINK, opacity=0.5)  # set the color and transparency
              self.play(Create(circle))  # show the circle on screen
    PYTHON

    system bin/"manim", "-ql", testpath/"testscene.py", "CreateCircle"
    assert_path_exists testpath/"media/videos/testscene/480p15/CreateCircle.mp4"
  end
end
