class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/83/5f/717ba528eb191124211036ec710bafd605dc7f7bb948a41219a8dd1124b6/manim-0.18.1.tar.gz"
  sha256 "4bf2b479d258b410259c6828261fe79e107beb8f2dd04ebfa73b96bcefdde93d"
  license "MIT"
  revision 2
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "2d24480cb3432ac84c65b6786b7dc1e3531207be140d1028e01f67fae105c452"
    sha256 cellar: :any,                 arm64_sonoma:   "d108d31fcffc46da729773754850637a05ddb4eda4b2437492f1e1ac941da88a"
    sha256 cellar: :any,                 arm64_ventura:  "b426acd4318a8878234f78aa553a1068b801a33706deaad530956ed52796aa61"
    sha256 cellar: :any,                 arm64_monterey: "c9e084c263f0a485d4803954c35f9d2c008331d9daca954d92e5fc4604a377fc"
    sha256 cellar: :any,                 sonoma:         "d463689bcc401300aaf81d7194b863b405d3f969f0832995a30be333e5bf8d8d"
    sha256 cellar: :any,                 ventura:        "fb64f12d5d4df9ee4693071614a36869e6b563bcfc25557086c8aaa07ce33985"
    sha256 cellar: :any,                 monterey:       "db86d235d0053376adc8d8d11d8fe65e7db88833a95aa21e81845c3b2e8bedc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84bf4558e70b655644cbd49e3dd1f36ecc683cfa6a80365285ca1c1914e4fb1e"
  end

  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "numpy"
  depends_on "pango"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "python@3.12"
  depends_on "scipy"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/cf/71/608e4546208e5a421ef00b484f582e58ce0f17da05459b915c8ba22dfb78/cloup-3.0.5.tar.gz"
    sha256 "c92b261c7bb7e13004930f3fb4b3edad8de2d1f12994dcddbe05bc21990443c5"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/d5/f7/2fdd9205a2eedee7d9b0abbf15944a1151eb943001dbdc5233b1d1cfc34e/Cython-3.0.10.tar.gz"
    sha256 "dcc96739331fb854dcf503f94607576cfe8488066c61ca50dfd55836f132de99"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "glcontext" do
    url "https://files.pythonhosted.org/packages/5e/cc/b32b0cd5cd527a53ad9a90cd1cb32d1ff97127265cd026c052f8bb9e8014/glcontext-2.5.0.tar.gz"
    sha256 "0f70d4be0cdd2b532a16da76c8f786b6367754a4086aaadffdbf3e37badbad02"
  end

  resource "isosurfaces" do
    url "https://files.pythonhosted.org/packages/da/cf/bd7e70bb7b8dfd77afdc79aba8d83afd4a9263f045861cd4ddd34b7f6a12/isosurfaces-0.1.2.tar.gz"
    sha256 "fa51ebe864ea9355b26830e27fdd6a41d5a58b419fa8d4b47e3b8b80718d6e21"
  end

  resource "manimpango" do
    url "https://files.pythonhosted.org/packages/48/5b/d1249c3d90324a1d4dce4711e507c8ec87addca61d1304ffa55513783ba3/ManimPango-0.5.0.tar.gz"
    sha256 "299913bbccb0f15954b64401cf9df24607e1a01edda589ea77de1ed4cc2bc284"
  end

  resource "mapbox-earcut" do
    url "https://files.pythonhosted.org/packages/97/f9/38f72877be0a5bf35c04a75c8ceb261589f2807eeaffaa22055079f53839/mapbox_earcut-1.0.1.tar.gz"
    sha256 "9f155e429a22e27387cfd7a6372c3a3865aafa609ad725e2c4465257f154a438"
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
    url "https://files.pythonhosted.org/packages/25/e7/d731fc4b58cb729d337c829a62aa17bc2b70438fa59745c8c9f51e279f42/moderngl-5.10.0.tar.gz"
    sha256 "119c8d364dde3cd8d1c09f237ed4916617ba759954a1952df4694e51ee4f6511"
  end

  resource "moderngl-window" do
    url "https://files.pythonhosted.org/packages/36/36/4823988c2155974a334753bfeef9c772d7b49b7f5c01f3e8a44c3813781c/moderngl-window-2.4.6.tar.gz"
    sha256 "db9b4c27f35faa6f243b6d8cde6ada6da6e79541d62b8e536c0b20da29720c32"
  end

  resource "multipledispatch" do
    url "https://files.pythonhosted.org/packages/fe/3e/a62c3b824c7dec33c4a1578bcc842e6c30300051033a4e5975ed86cc2536/multipledispatch-1.0.0.tar.gz"
    sha256 "5c839915465c68206c3e9c473357908216c28383b425361e5d144594bf85a7e0"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "pycairo" do
    url "https://files.pythonhosted.org/packages/19/4f/0d48a017090d4527e921d6892bc550ae869902e67859fc960f8fe63a9094/pycairo-1.26.1.tar.gz"
    sha256 "a11b999ce55b798dbf13516ab038e0ce8b6ec299b208d7c4e767a6f7e68e8430"
  end

  resource "pydub" do
    url "https://files.pythonhosted.org/packages/fe/9a/e6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fd/pydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyglet" do
    url "https://files.pythonhosted.org/packages/a2/14/6cb89978608e2a2f5869eab9485f8f1eabaf2240a63d6c9bc23c43d952c5/pyglet-2.0.15.tar.gz"
    sha256 "42085567cece0c7f1c14e36eef799938cbf528cfbb0150c484b984f3ff1aa771"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b7/40/a38d78627bd882d86c447db5a195ff307001ae02c1892962c656f2fd6b83/pyobjc_core-10.3.1.tar.gz"
    sha256 "b204a80ccc070f9ab3f8af423a3a25a6fd787e228508d00c4c30f8ac538ba720"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/a7/6c/b62e31e6e00f24e70b62f680e35a0d663ba14ff7601ae591b5d20e251161/pyobjc_framework_cocoa-10.3.1.tar.gz"
    sha256 "1cf20714daaa986b488fb62d69713049f635c9d41a60c8da97d835710445281a"
  end

  resource "pyrr" do
    url "https://files.pythonhosted.org/packages/e5/7f/2af23f61340972116e4efabc3ac6e02c8bad7f7315b3002c278092963f17/pyrr-0.10.3.tar.gz"
    sha256 "3c0f7b20326e71f706a610d58f2190fff73af01eef60c19cb188b186f0ec7e1d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "screeninfo" do
    url "https://files.pythonhosted.org/packages/ec/bb/e69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27/screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "skia-pathops" do
    url "https://files.pythonhosted.org/packages/37/15/fa6de52d9cb3a44158431d4cce870e7c2a56cdccedc8fa1262cbf61d4e1e/skia-pathops-0.8.0.post1.zip"
    sha256 "a056249de2f61fa55116b9ee55513c6a36b878aee00c91450e404d1606485cbb"
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
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/1b/f9/b01e4632aed9a6ecc2b3e501feffd3af5aa0eb4e3b0283fc9525bf503c38/watchdog-4.0.1.tar.gz"
    sha256 "eebaacf674fa25511e8867028d281e602ee6500045b57f43b08778082f7f8b44"
  end

  def install
    python = "python3.12"
    ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python)
    venv = virtualenv_create(libexec, python)
    venv.pip_install resources.reject { |r| r.name.start_with?("pyobjc") && OS.linux? }
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"testscene.py").write <<~EOS
      from manim import *

      class CreateCircle(Scene):
          def construct(self):
              circle = Circle()  # create a circle
              circle.set_fill(PINK, opacity=0.5)  # set the color and transparency
              self.play(Create(circle))  # show the circle on screen
    EOS

    system bin/"manim", "-ql", "#{testpath}/testscene.py", "CreateCircle"
    assert_predicate testpath/"media/videos/testscene/480p15/CreateCircle.mp4", :exist?
  end
end
