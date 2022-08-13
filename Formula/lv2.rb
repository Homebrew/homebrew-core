class Lv2 < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.8.tar.xz"
  sha256 "b404cf14f776af40ca43808b45f4219dfa850a4f47aa33f89fa96ae719e174c8"
  license "ISC"
  head "https://gitlab.com/lv2/lv2.git", branch: "master"

  livecheck do
    url "https://lv2plug.in/spec/"
    regex(/href=.*?lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c779a2bdcc5e2fe16c654f4dce7a2431b6b69604290c11cbbddace913762225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713c9d23988b6efa19642df60680068b7bee5f1b811c178d34a85dcef57dbb0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b34f9fb3c117c3d59cebc4befdeb2f62c396a8dc5cfb534b0f2866d7d3919ad4"
    sha256 cellar: :any_skip_relocation, big_sur:        "de621f9b73c50276e64ea60ebd5001c6151c2b9648f25c4664efee5f4d4ab6c2"
    sha256 cellar: :any_skip_relocation, catalina:       "6db7da8717d6cfe061c132693fe141bc88da3c1c0c447c59452a995a02a3a8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d1abb14fbaabc01ac4329148014da9bb6c85a961b5f9223df6a52e834a96de3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
    sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/fc/8d/2d1c8a08471b4333657c98a3048642095f844f10cd1d4e28f9b08725c7bd/rdflib-6.2.0.tar.gz"
    sha256 "62dc3c86d1712db0f55785baf8047f63731fa59b2682be03219cb89262065942"
  end

  def install
    # Python resources and virtualenv are for the lv2specgen.py script that is installed
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    rw_info = python_shebang_rewrite_info("#{libexec}/bin/python3")
    rewrite_shebang rw_info, *Dir.glob("lv2specgen/*.py")

    system "meson", "build", *std_meson_args, "-Dplugins=disabled", "-Dlv2dir=#{lib}/lv2"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"

    (libexec/"bin").install bin/"lv2specgen.py"
    (bin/"lv2specgen.py").write_env_script libexec/"bin/lv2specgen.py",
                                           XDG_DATA_DIRS: "#{opt_share}${XDG_DATA_DIRS+:${XDG_DATA_DIRS}}"
    (pkgshare/"example").install "plugins/eg-amp.lv2/amp.c"
  end

  test do
    output = shell_output("#{bin}/lv2specgen.py --help")

    # lv2specgen.py will only display help text if it is able to load required Python modules
    assert_match "Write HTML documentation for an RDF ontology.", output

    # Pygments support in lv2specgen.py is optional, ensure that there were no errors in loading Pygments
    refute_match "Error importing pygments, syntax highlighting disabled.", output

    # Try building a simple lv2 plugin
    dynamic_flag = OS.mac? ? "-dynamiclib" : "-shared"
    system ENV.cc, pkgshare/"example/amp.c", "-I#{include}",
           "-DEG_AMP_LV2_VERSION=1.0.0", "-DHAVE_LV2=1", "-fPIC", dynamic_flag,
           "-o", shared_library("amp")
  end
end
