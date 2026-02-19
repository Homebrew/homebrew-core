class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/6b/be/39066e0f1ad3c12532ee4f1dcfd02088b0aa0de9d38ba266a198ab1c09e9/manim-0.19.2.tar.gz"
  sha256 "7cf74d7c012f19e278fcff58651e5b486a23391aa115582a24c6a0e318cd243e"
  license "MIT"
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  # FIXME: Fails trying to resolve pycairo as pip tries compiling it but cannot find cairo
  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "397cbfb8d34e8d2297b569fb4128b5d70aef4ce852bc4c1ca9189d4b1deae3dc"
    sha256 cellar: :any,                 arm64_sequoia: "11479f24bdd72bcefbaf75930d20172c4af0b4831b5bee347b7ab73c49254d8f"
    sha256 cellar: :any,                 arm64_sonoma:  "c9f63f8550f77dfd804839fc57c95ba9ddf980e4b79b3a2d0d06596717dd10bc"
    sha256 cellar: :any,                 sonoma:        "83d40bd31e373cc3259546934ce847f90240d136c72568e180151cecac634c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd58a0a7d7a0c665d49a27a2eb54d15529b066f869b5f0327d3042d65704a586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6080aa6bc77054ea8cd01a9f2f1f621cfc9d67be787f1fb4241ba45ba491c15f"
  end

  depends_on "cmake" => :build # for mapbox_earcut
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
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

  fails_with :clang do
    build 1699
    cause "pyobjc-core uses `-fdisable-block-signature-string`"
  end

  pypi_packages exclude_packages: %w[numpy pillow pycairo scipy]

  resource "audioop-lts" do
    url "https://files.pythonhosted.org/packages/38/53/946db57842a50b2da2e0c1e34bd37f36f5aadba1a929a3971c5d7841dbca/audioop_lts-0.2.2.tar.gz"
    sha256 "64d0c62d88e67b98a1a5e71987b7aa7b5bcffc7dcee65b635823dbdd0a8dbbd0"
  end

  resource "av" do
    url "https://files.pythonhosted.org/packages/78/cd/3a83ffbc3cc25b39721d174487fb0d51a76582f4a1703f98e46170ce83d4/av-16.1.0.tar.gz"
    sha256 "a094b4fd87a3721dacf02794d3d2c82b8d712c85b9534437e82a8a978c175ffd"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/46/cf/09a31f0f51b5c8ef2343baf37c35a5feb4f6dfdcbd0592a014baf837f2e4/cloup-3.0.8.tar.gz"
    sha256 "f91c080a725196ddf74feabd6250266f466e97fc16dfe21a762cf6bc6beb3ecb"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/91/85/7574c9cd44b69a27210444b6650f6477f56c75fee1b70d7672d3e4166167/cython-3.2.4.tar.gz"
    sha256 "84226ecd313b233da27dc2eb3601b4f222b8209c3a7216d8733b031da1dc64e6"
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
    url "https://files.pythonhosted.org/packages/47/55/d360e73eb4d04b102cef399ddebcba486a9b6c1977a26fe710beffd52e95/manimpango-0.6.1.tar.gz"
    sha256 "59a00bbf8e99dab5f94341087c88e609fe946e79724627429cf59da84cbd40bf"
  end

  resource "mapbox-earcut" do
    url "https://files.pythonhosted.org/packages/bc/7b/bbf6b00488662be5d2eb7a188222c264b6f713bac10dc4a77bf37a4cb4b6/mapbox_earcut-2.0.0.tar.gz"
    sha256 "81eab6b86cf99551deb698b98e3f7502c57900e5c479df15e1bdaf1a57f0f9d6"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
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
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "pydub" do
    url "https://files.pythonhosted.org/packages/fe/9a/e6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fd/pydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyglet" do
    url "https://files.pythonhosted.org/packages/77/b4/b78df1ec545a151cb7ee64a1632e8f33ba8bd1a97329e4918e76761a80d9/pyglet-2.1.13.tar.gz"
    sha256 "37a31c212b51658f7c125613f93818a199e8808f86e9b1abe7bfe5395661eee3"
  end

  resource "pyglm" do
    url "https://files.pythonhosted.org/packages/41/8b/bdaf7b9cacecd28f7b4c6fc2d7d136824c506ad38cfdb37a05ea7ec88694/pyglm-2.8.3.tar.gz"
    sha256 "161781ea4d1267f796b645f85ebff53aeb8ee4f13b4e993c04d64c96d286e534"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/99/a4cab2acbb884f80e558b0771e97e21e939c5dfb460f488d19df485e8298/rich-14.3.2.tar.gz"
    sha256 "e712f11c1a562a11843306f5ed999475f09ac31ffb64281f73ab29ffdda8b3b8"
  end

  resource "screeninfo" do
    url "https://files.pythonhosted.org/packages/ec/bb/e69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27/screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "skia-pathops" do
    url "https://files.pythonhosted.org/packages/4a/f6/ab37d6fa21f25965d4ad059745c76f13ddfb92a2c06a842a42ad77961c24/skia_pathops-0.9.2.tar.gz"
    sha256 "4b6d8459f6f4a69282cb26fca0c2bb0b321cc58a9bf9cc6579a52a391edc0319"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
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
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
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
