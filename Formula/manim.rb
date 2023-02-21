class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/6e/ee/281ccf843f15700fa2221334ac7590627496a4d6645da2dcf150450628ec/manim-0.17.2.tar.gz"
  sha256 "cb9b6f8b27c07994b929f2ab1943a3f5a6767816391744bb0f64f998dd99ecfe"
  license "MIT"
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  depends_on "ninja" => :build
  depends_on "ffmpeg"
  depends_on "py3cairo"
  depends_on "python@3.11"

  on_arm do
    depends_on "pango"
    depends_on "scipy"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/91/45/cd87cc781c4b8be8f3c010946186271d6072ce2d6283ada9ef37d0218110/cloup-0.13.1.tar.gz"
    sha256 "ea0acc67eed994b86e79b70d76bc2ea525b7f98f3cd8e63696896d549597ef4d"
  end

  resource "colour" do
    url "https://files.pythonhosted.org/packages/a0/d4/5911a7618acddc3f594ddf144ecd8a03c29074a540f4494670ad8f153efe/colour-0.1.5.tar.gz"
    sha256 "af20120fefd2afede8b001fbef2ea9da70ad7d49fafdb6489025dae8745c3aee"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/dc/f6/e8e302f9942cbebede88b1a0c33d0be3a738c3ac37abae87254d58ffc51c/Cython-0.29.33.tar.gz"
    sha256 "5040764c4a4d2ce964a395da24f0d1ae58144995dab92c6b96f44c3f4d72286a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "glcontext" do
    url "https://files.pythonhosted.org/packages/24/41/181a4354bf6373bc8a704f30a8fc059eed87bea7d77a1eb79fb57c8772b9/glcontext-2.3.7.tar.gz"
    sha256 "bb2d0503f45ad85ca7319bd37fd983e374b3f824c38a450b5f72cfc974114156"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isosurfaces" do
    url "https://files.pythonhosted.org/packages/88/b6/765e74b3ce5b40cf21b95eef7e60c7755314538908287ec2d0767b17bd2d/isosurfaces-0.1.0.tar.gz"
    sha256 "fa1b44e5e59d2f429add49289ab89e36f8dcda49b7badd99e0beea273be331f4"
  end

  resource "ManimPango" do
    url "https://files.pythonhosted.org/packages/2b/2e/a426d0b799747de3da775d56116128a23b2a2c4836fb97daea30137a5e1f/ManimPango-0.4.3.tar.gz"
    sha256 "732f1cb98bcc122c0dee93bb54966aa595f90730e5096ad6d86602cf4ba1a103"
  end

  resource "mapbox-earcut" do
    url "https://files.pythonhosted.org/packages/97/f9/38f72877be0a5bf35c04a75c8ceb261589f2807eeaffaa22055079f53839/mapbox_earcut-1.0.1.tar.gz"
    sha256 "9f155e429a22e27387cfd7a6372c3a3865aafa609ad725e2c4465257f154a438"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/33/e9/ac8a93e9eda3891ecdfecf5e01c060bbd2c44d4e3e77efc83b9c7ce9db32/markdown-it-py-2.1.0.tar.gz"
    sha256 "cf7e59fed14b5ae17c0006eff14a2d9a00ed5f3a846148153899a0224e2c07da"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "moderngl" do
    url "https://files.pythonhosted.org/packages/2b/fa/a04279fad74b9e3c36f30963f9a8b1586930d246728b858cf5cc90bdd699/moderngl-5.7.4.tar.gz"
    sha256 "20f821bf66b2811bc8648d7cf7f64402afff7619fea271f42a6ee85fe03e4041"
  end

  resource "moderngl-window" do
    url "https://files.pythonhosted.org/packages/f8/06/c47b5101242189d75ca2a37e74f4c833a48872678fb097741f02b06c659b/moderngl-window-2.4.1.tar.gz"
    sha256 "691de764640b87af3d851257be544e1cafddb9cfa47cb144d0c1f1a0ed0a3936"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/cd/16/c44e8550012735b8f21b3df7f39e8ba5a987fb764ac017ad5f3589735889/networkx-2.8.8.tar.gz"
    sha256 "230d388117af870fce5647a3c52401fcf753e94720e6ea6b4197a5355648885e"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/ce/b8/c170db50ec49d5845bd771bc5549fe734ee73083c5c52791915f95d8e2bc/numpy-1.24.1.tar.gz"
    sha256 "2386da9a471cc00a1f47845e27d916d5ec5346ae9696e01a8a34760858fe9dd2"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/bc/07/830784e061fb94d67649f3e438ff63cfb902dec6d48ac75aeaaac7c7c30e/Pillow-9.4.0.tar.gz"
    sha256 "a1c2d7780448eb93fbcc3789bf3916aa5720d942e37945f4056680317f1cd23e"
  end

  resource "pycairo" do
    url "https://files.pythonhosted.org/packages/69/ca/9e9fa2e8be0876a9bbf046a1be7ee33e61d4fdfbd1fd25c76c1bdfddf8c4/pycairo-1.23.0.tar.gz"
    sha256 "9b61ac818723adc04367301317eb2e814a83522f07bbd1f409af0dada463c44c"
  end

  resource "pydub" do
    url "https://files.pythonhosted.org/packages/fe/9a/e6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fd/pydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/1e/20/75b43cd85d8676d15f7d3876e8b64415bfd7b7f937710f9966738723daf3/pyobjc-core-9.0.1.tar.gz"
    sha256 "5ce1510bb0bdff527c597079a42b2e13a19b7592e76850be7960a2775b59c929"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/b5/35/da77d26b9b6ee97fede0a9364273aaa7970fea7947d15c0e28efd345db0e/pyobjc-framework-Cocoa-9.0.1.tar.gz"
    sha256 "a8b53b3426f94307a58e2f8214dc1094c19afa9dcb96f21be12f937d968b2df3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/9e/5e/c3dc3ea32e2c14bfe46e48de954dd175bff76bcc549dd300acb9689521ae/rich-13.2.0.tar.gz"
    sha256 "f1a00cdd3eebf999a15d85ec498bfe0b1a77efe9b34f645768a54132ef444ac5"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/d6/bd/2d13a273d95f7b7d9903c906c486040b0aebb85e008f93a5dd0891f21f1f/scipy-1.10.0.tar.gz"
    sha256 "c8b3cbc636a87a89b770c6afc999baa6bcbb01691b5ccbbc1b1791c7c0a07540"
  end

  resource "screeninfo" do
    url "https://files.pythonhosted.org/packages/ec/bb/e69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27/screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "skia-pathops" do
    url "https://files.pythonhosted.org/packages/0c/9c/402e16ae956a10d56fe1ab9969136f92e043f8fafdbb3a63ed00b5c43ad0/skia-pathops-0.7.4.zip"
    sha256 "0a2fdee87b7adb018cbfa6e95ef9e4299ed63b0080be27677a30ffefbca91350"
  end

  resource "srt" do
    url "https://files.pythonhosted.org/packages/18/a3/e1466f7c86a9e5d3e462ed6eb3a548917e93cc1ee212cd927f8f4e887ae9/srt-3.5.2.tar.gz"
    sha256 "7aa4ad5ce4126d3f53b3e7bc4edaa86653d0378bf1c0b1ab8c59f5ab41384450"
  end

  resource "svgelements" do
    url "https://files.pythonhosted.org/packages/a0/b7/30b8443a6ec95021e9cb3b69130e146a2ddf26a56ac6837c6fa330cd7454/svgelements-1.9.0.tar.gz"
    sha256 "21ce32f188d7968da07f585d88141c0cd8638049a68813d69c7eb941fa09fad6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/11/6f/0396d373e039b89c60e23a1a9025edc6dd203121fe0af7d1427e85d5ec98/watchdog-2.2.1.tar.gz"
    sha256 "cdcc23c9528601a8a293eb4369cbd14f6b4f34f07ae8769421252e9c22718b6f"
  end

  def install
    virtualenv_install_with_resources
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
