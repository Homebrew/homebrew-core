class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/52/79/29f287beebcf52464c2cfd88015720992515062dd373bd37c2ed34955cdd/manim-0.19.0.tar.gz"
  sha256 "748115ffc1dea24940fd6d7a3edcae0ccedc3e1874ebc1f5d7e5c6d69a4f4505"
  license "MIT"
  revision 1
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "718bc3d08a4fb47ee15142edf3e0650b7c2f232047330d011c8aea88c2301c59"
    sha256 cellar: :any,                 arm64_sequoia: "77154bf5226d7f19c505699c21f54bebeec4def08053eabf110097eccf0605ed"
    sha256 cellar: :any,                 arm64_sonoma:  "3db1d9748f59313478c70ac898e9c53a2475c1c93afe145f2324c96879486985"
    sha256 cellar: :any,                 sonoma:        "8c2a0b447fbcafd7dbfc6a3f5f8a5f0fb136a22b8aac9b69f5b47438055f44a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06198e65f21538891c164ba65902269f18b524ff1233f236effda146712514b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bfff49f7410cb89bcfa2d5e153cd0ab679e00e501b3ee20db106850bb38ee8d"
  end

  depends_on "cmake" => :build # for mapbox_earcut
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg@7" # FFmpeg 8 needs av>=15.1.0, https://github.com/ManimCommunity/manim/pull/4385
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "numpy" => :no_linkage
  depends_on "pango"
  depends_on "pillow" => :no_linkage
  depends_on "py3cairo"
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: ["pillow", "numpy", "scipy"]

  resource "audioop-lts" do
    url "https://files.pythonhosted.org/packages/38/53/946db57842a50b2da2e0c1e34bd37f36f5aadba1a929a3971c5d7841dbca/audioop_lts-0.2.2.tar.gz"
    sha256 "64d0c62d88e67b98a1a5e71987b7aa7b5bcffc7dcee65b635823dbdd0a8dbbd0"
  end

  resource "av" do
    url "https://files.pythonhosted.org/packages/0c/9d/486d31e76784cc0ad943f420c5e05867263b32b37e2f4b0f7f22fdc1ca3a/av-13.1.0.tar.gz"
    sha256 "d3da736c55847d8596eb8c26c60e036f193001db3bc5c10da8665622d906c17e"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/46/cf/09a31f0f51b5c8ef2343baf37c35a5feb4f6dfdcbd0592a014baf837f2e4/cloup-3.0.8.tar.gz"
    sha256 "f91c080a725196ddf74feabd6250266f466e97fc16dfe21a762cf6bc6beb3ecb"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/4d/ab/4e980fbfbc894f95854aabff68a029dd6044a9550c480a1049a65263c72b/cython-3.1.5.tar.gz"
    sha256 "7e73c7e6da755a8dffb9e0e5c4398e364e37671778624188444f1ff0d9458112"
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
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
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
    url "https://files.pythonhosted.org/packages/1a/98/c8c7c8ac2911ba7c547dfb2be3d9ce69ed0fa98b166d0c8a6cf7c01f44cd/pyglet-2.1.9.tar.gz"
    sha256 "855bb55ffe05d98e95a7e4ad72969cb2ba8d57edbd6a7515db51a0479287f014"
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
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
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
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
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
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
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

    generate_completions_from_executable(bin/"manim", shell_parameter_format: :click)
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
