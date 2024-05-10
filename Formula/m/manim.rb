class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/83/5f/717ba528eb191124211036ec710bafd605dc7f7bb948a41219a8dd1124b6/manim-0.18.1.tar.gz"
  sha256 "4bf2b479d258b410259c6828261fe79e107beb8f2dd04ebfa73b96bcefdde93d"
  license "MIT"
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "110296f6ea37d0353d50d0c928ac0bf9998a5aa188f0f80b90c9d88ce63ac95a"
    sha256 cellar: :any,                 arm64_ventura:  "6982e1c2fc74f24afe2993a05dd5edcb4b8137501bd6f345428da02cb9217e49"
    sha256 cellar: :any,                 arm64_monterey: "5d37b335590e7198d0b54506bfa638f1501a4e32d4c728b6a0f869c1b2890bdc"
    sha256 cellar: :any,                 sonoma:         "f4546e242f9de6fdd7fd3483bf348729f7dea80ad93354a0e4fadfcceae1abc9"
    sha256 cellar: :any,                 ventura:        "6ca3380e3f568150c1dc80582e7b7ca74a293d4bdea1beb1bf87e175bc01b068"
    sha256 cellar: :any,                 monterey:       "95ad93740a778272d84e2ed6316c499ca109aaf5bbb48e9b9e5113ece5867f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d5a0ae9b9c5c81dd9f4478e0bf08d56f973c788eed83358d0c96757001f05a"
  end

  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "python@3.12"

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  on_arm do
    depends_on "pango"
    depends_on "scipy"
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
    url "https://files.pythonhosted.org/packages/4e/d7/3467a5cb0cbd3b9bb15c6a10f793f59bb606862c1c7c704af483156e5c7c/moderngl-window-2.4.5.tar.gz"
    sha256 "2ee6e80b215ce4e7db5bef8d166010a3f2b9060449688652bfe06fa7c904d01b"
  end

  resource "multipledispatch" do
    url "https://files.pythonhosted.org/packages/fe/3e/a62c3b824c7dec33c4a1578bcc842e6c30300051033a4e5975ed86cc2536/multipledispatch-1.0.0.tar.gz"
    sha256 "5c839915465c68206c3e9c473357908216c28383b425361e5d144594bf85a7e0"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/64/9e/7e638579cce7dc346632f020914141a164a872be813481f058883ee8d421/Pillow-10.0.1.tar.gz"
    sha256 "d72967b06be9300fed5cfbc8b5bafceec48bf7cdc7dab66b1d2549035287191d"
  end

  resource "pycairo" do
    url "https://files.pythonhosted.org/packages/1c/41/91955188e97c7b85fbaac6bbf4e33de028899e0aa31bdce99b1afe2eeb17/pycairo-1.26.0.tar.gz"
    sha256 "2dddd0a874fbddb21e14acd9b955881ee1dc6e63b9c549a192d613a907f9cbeb"
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
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/24/ac/61c58e65780c6ba0523997d236fac99e38e5ddfabfd5b500409f8239a257/pyobjc-core-10.2.tar.gz"
    sha256 "0153206e15d0e0d7abd53ee8a7fbaf5606602a032e177a028fc8589516a8771c"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/b0/c0/7eb30628e1a60c8b700f0b15280417c754eda9f186d05d47f4cac6f4e1a7/pyobjc-framework-Cocoa-10.2.tar.gz"
    sha256 "6383141379636b13855dca1b39c032752862b829f93a49d7ddb35046abfdc035"
  end

  resource "pyrr" do
    url "https://files.pythonhosted.org/packages/e5/7f/2af23f61340972116e4efabc3ac6e02c8bad7f7315b3002c278092963f17/pyrr-0.10.3.tar.gz"
    sha256 "3c0f7b20326e71f706a610d58f2190fff73af01eef60c19cb188b186f0ec7e1d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/fb/a3/328965862f41ba67d27ddd26205962007ec87d99eec6d364a29bf00ac093/scipy-1.13.0.tar.gz"
    sha256 "58569af537ea29d3f78e5abd18398459f195546bb3be23d16677fb26616cc11e"
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
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/cd/3c/43eeaa9ea17a2657d639aa3827beaa77042809410f86fb76f0d0ea6a2102/watchdog-4.0.0.tar.gz"
    sha256 "e3e7065cbdabe6183ab82199d7a4f6b3ba0a438c5a512a68559846ccb76a78ec"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
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
