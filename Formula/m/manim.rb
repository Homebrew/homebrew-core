class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https://www.manim.community"
  url "https://files.pythonhosted.org/packages/98/fa/cef49e8c5c5617232ae8324a8ad14d8d724eb308dc898687240daca2800b/manim-0.22.0.tar.gz"
  sha256 "e227aef6dab218c7fe68fa31ed1ff418e1c86a450f43509ed2630f3ffd06602d"
  license "MIT"
  head "https://github.com/manimCommunity/manim.git", branch: "main"

  # FIXME: Fails trying to resolve pycairo as pip tries compiling it but cannot find cairo
  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b93954efecd0ba30bc699e51eb59ff2b401d60ac226c3513bc286966f2f1d60d"
    sha256 cellar: :any, arm64_tahoe:       "0544285acdfbd4e7f83e392117f1cc5f959e3ccc2ac94e0305c5d799750eed26"
    sha256 cellar: :any, arm64_sequoia:     "4ea44b9a2c2634991fa61606f8be97097b473a11d1176c04a36f49d1ee706743"
    sha256 cellar: :any, arm64_linux:       "f0439930974ef07f90b09e1933edb258e20a74ccbd4dfb4124b5cdf1c686d55b"
    sha256 cellar: :any, x86_64_linux:      "fd42d4bc5878e141e2e206a40e72430e6c8a0d490349b53b38314e76e3127582"
  end

  depends_on "cmake" => :build # for mapbox_earcut
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "numpy" => :no_linkage
  depends_on "pango"
  depends_on "pillow" => :no_linkage
  depends_on "py3cairo"
  depends_on "python@3.15"
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
    url "https://files.pythonhosted.org/packages/90/bc/a2a40e503250fe5d4174471911828f31658864eb69a8a7cb960c715e17b7/av-19.0.1.tar.gz"
    sha256 "08674930eaf1af78a3ed8f93d3ba49383323b3a867e84349d9c399e36f7497da"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "glcontext" do
    url "https://files.pythonhosted.org/packages/5f/99/e877a962bfa5783f6c01116483471f0666b53d5f805ea0ebdbb0c66d159b/glcontext-3.1.0.tar.gz"
    sha256 "754d33f73aaf07e016e503b722e44c6ef914d9f101643be524cb185e1d55717f"
  end

  resource "isosurfaces" do
    url "https://files.pythonhosted.org/packages/da/cf/bd7e70bb7b8dfd77afdc79aba8d83afd4a9263f045861cd4ddd34b7f6a12/isosurfaces-0.1.2.tar.gz"
    sha256 "fa51ebe864ea9355b26830e27fdd6a41d5a58b419fa8d4b47e3b8b80718d6e21"
  end

  resource "manimpango" do
    url "https://files.pythonhosted.org/packages/88/35/30bfde8a5fbb82392755d078e41d3f43b686fa2feb4f8c25c12435e23892/manimpango-0.7.0.tar.gz"
    sha256 "64330c360f5040ed356b9eb289d52e8ae8cbc3d9c39297c5e77522e1b417f1c7"
  end

  resource "mapbox-earcut" do
    url "https://files.pythonhosted.org/packages/aa/14/8505f246191c41da54a64a4d6c30049ed47b6047930d8f0de328dadb06ee/mapbox_earcut-2.1.0.tar.gz"
    sha256 "fb0c1e43581a635bbaabf4a5149009014d370c515816c4d5a7d8118477f28d48"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "moderngl" do
    url "https://files.pythonhosted.org/packages/92/8a/c39cf051226c51105aac20bbe613a0ef05d006c2f2b2403fad25ca80a23c/moderngl-5.13.0.tar.gz"
    sha256 "7e8b39e85702e097c4d680f6cc0c51aabf0c1eac741719a159ac405d37c95404"
  end

  resource "moderngl-window" do
    url "https://files.pythonhosted.org/packages/90/02/92e235891300c901f59647112a0267a07454f58aeb2041aa44f6b85f9cb3/moderngl_window-3.1.1.tar.gz"
    sha256 "29c2827505f87399f3461d480b2778910fddeebe44ea803301215cf212a6c1bc"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "pydub" do
    url "https://files.pythonhosted.org/packages/fe/9a/e6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fd/pydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyglet" do
    url "https://files.pythonhosted.org/packages/49/5f/cd70a861e9a9da09dd3449619393095f38c47ad63ce9dd1da8c6979f5eec/pyglet-2.1.17.tar.gz"
    sha256 "3cae0682fc5180122800fce8ae86987c7b45ca154da85ff084bad8bfd00ae03e"
  end

  resource "pyglm" do
    url "https://files.pythonhosted.org/packages/41/8b/bdaf7b9cacecd28f7b4c6fc2d7d136824c506ad38cfdb37a05ea7ec88694/pyglm-2.8.3.tar.gz"
    sha256 "161781ea4d1267f796b645f85ebff53aeb8ee4f13b4e993c04d64c96d286e534"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/a5/78/abc4ce5920305780aeb36b4067a86253378b36e29ba96673a3deb02eb03a/pyobjc_core-12.2.2.tar.gz"
    sha256 "3906452339cd06a3bb07df103c2511d4cb0f7a22d8771c0b802eba15d9a642b6"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/75/76/49c6da2c6a831020b4854ba20079d5a1030474bffc776b7b73c2eeff8c15/pyobjc_framework_cocoa-12.2.2.tar.gz"
    sha256 "c96c0ef69a71afbbb0e6a7d594b455c5fe47d62e0db376ee7a2b4b828c16ace9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
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
    url "https://files.pythonhosted.org/packages/71/c3/1b817965ac12dc002d7c9cd7dfffdd7d4fbf9b45763ef2ffe7b86ee94670/soupsieve-2.10.tar.gz"
    sha256 "49e9380d7d2905463583bafe285e818c7366a9ed7b3aee221c1ac79c905d8bc0"
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
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
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
