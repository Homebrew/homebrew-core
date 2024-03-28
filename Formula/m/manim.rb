class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/06/62/7802597b93048a8ab543d835338739ce8f4e96e0410b63e29c86deb7cceb/manim-0.18.0.tar.gz"
  sha256 "56788066bc1aec2471a988c91e337194fd38d1035ed1b4d10838bfe64bd26af8"
  license "MIT"
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "python-setuptools" # for `import pkg_resources`
  depends_on "python@3.12"

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  on_arm do
    depends_on "pango"
    depends_on "scipy"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/71/b6/2819a7290c0f5bf384be3f507f2cfbc0a93a8148053d0bde2040d2e09124/cloup-2.1.2.tar.gz"
    sha256 "43f10e944056f3a1eea714cb67373beebebbefc3f4551428750392f3e04ac964"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/0e/17/c5b026cea7a634ee3b8950a7be16aaa49deeb3b9824ba5e81c13ac26f3c4/Cython-3.0.9.tar.gz"
    sha256 "a2d354f059d1f055d34cfaa62c5b68bc78ac2ceab6407148d47fb508cf3ba4f3"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "glcontext" do
    url "https://files.pythonhosted.org/packages/5e/cc/b32b0cd5cd527a53ad9a90cd1cb32d1ff97127265cd026c052f8bb9e8014/glcontext-2.5.0.tar.gz"
    sha256 "0f70d4be0cdd2b532a16da76c8f786b6367754a4086aaadffdbf3e37badbad02"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "isosurfaces" do
    url "https://files.pythonhosted.org/packages/88/b6/765e74b3ce5b40cf21b95eef7e60c7755314538908287ec2d0767b17bd2d/isosurfaces-0.1.0.tar.gz"
    sha256 "fa1b44e5e59d2f429add49289ab89e36f8dcda49b7badd99e0beea273be331f4"
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
    url "https://files.pythonhosted.org/packages/c2/90/14a7e798c9310dfa5ee94716d0b73f465780741ae6c9d45eb21626d87bf6/moderngl-window-2.4.4.tar.gz"
    sha256 "66a9c5412b5eb0a5ca7cda351e4484ce02a167cf87eb4dc59bb82439c58130b5"
  end

  resource "multipledispatch" do
    url "https://files.pythonhosted.org/packages/fe/3e/a62c3b824c7dec33c4a1578bcc842e6c30300051033a4e5975ed86cc2536/multipledispatch-1.0.0.tar.gz"
    sha256 "5c839915465c68206c3e9c473357908216c28383b425361e5d144594bf85a7e0"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/00/d5/4903f310765e0ff2b8e91ffe55031ac6af77d982f0156061e20a4d1a8b2d/Pillow-9.5.0.tar.gz"
    sha256 "bf548479d336726d7a0eceb6e767e179fbde37833ae42794602631a070d630f1"
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
    url "https://files.pythonhosted.org/packages/f5/fa/9b701ace19219b38dca47926a500dafa9f37cf33c7935e699c9218b35062/pyglet-2.0.14.tar.gz"
    sha256 "9b3bef1532395d88600db115b2eea8c345d2851be48ad8ac64b152b16f089777"
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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/30/85/cdbf2c3c460fe5aae812917866392068a88d02f07de0fe31ce738734c477/scipy-1.12.0.tar.gz"
    sha256 "4bf5abab8a36d20193c698b0f1fc282c1d083c94723902c447e5d2f1780936a3"
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
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
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
