class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "54306d65060bd58ed8b3dab1a8af521aeb4fd417871f15f463ff05ccb4e121fe"
  license :cannot_represent
  revision 2
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f76f4858674072e0992eb5a2d004e2c088556c460ee98cadd828dc3c0c9b453"
    sha256 cellar: :any,                 arm64_sequoia: "df129b99341114fdc3cbbcfbd469bb563e10af06dcb8fbfaa417dfec84c6b973"
    sha256 cellar: :any,                 arm64_sonoma:  "e7ec9b524c7b30829ca8ed8e4e4195db5e687a0b2de3a5ea92cc569a4c092ff5"
    sha256 cellar: :any,                 sonoma:        "808c4b989cb6240b0e3172d5279f8fce333231e33bbcf5c6f51f55c840632582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c06f9389168a9a133cbe6dfc12a150fdd36a90e3268af20f1120f1e00703958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291e786a0fd830c0a55b2db5fa0ff7d08b27140938a990549ea75fc1974e758b"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "msgpack-cxx" => :build
  depends_on "sip" => :build

  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "freeglut"
    depends_on "mesa"
  end

  resource "mmtf-cpp" do
    url "https://github.com/rcsb/mmtf-cpp/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "021173bdc1814b1d0541c4426277d39df2b629af53151999b137e015418f76c0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "mmtf-python" do
    url "https://files.pythonhosted.org/packages/d8/0f/f3c132dc9aac9a3f32a0eba7a80f07d14e7624e96f9245eeac5fe48f42cd/mmtf-python-1.1.3.tar.gz"
    sha256 "12a02fe1b7131f0a2b8ce45b46f1e0cdd28b9818fe4499554c26884987ea0c32"
  end

  resource "pmw" do
    url "https://github.com/schrodinger/pmw-patched/archive/8bedfc8747e7757c1048bc5e11899d1163717a43.tar.gz"
    sha256 "3a59e6d33857733d0a8ff0c968140b8728f8e27aaa51306160ae6ab13cea26d3"
  end

  # Allow numpy 2+, remove on next release
  patch do
    url "https://github.com/schrodinger/pymol-open-source/commit/1b3aca8c053336fc5c7f72e79b4801f8fdd1af39.patch?full_index=1"
    sha256 "639261ff5b4d9c930ead3179cbbf64bf1e8fa575678561a0287c11f5a6cfa4d6"
  end

  def python3
    which("python3.14")
  end

  def install
    resource("mmtf-cpp").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"mmtf")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    inreplace "setup.py" do |s|
      s.gsub!(/ no_glut = True$/, " no_glut = False")
      s.gsub!(/ use_msgpackc = "guess"$/, ' use_msgpackc = "c++11"')
    end

    ENV["PREFIX_PATH"] = "#{buildpath}/mmtf:#{ENV["CMAKE_PREFIX_PATH"]}"
    venv = virtualenv_install_with_resources without: "mmtf-cpp"
    (prefix/Language::Python.site_packages(python3)/"homebrew-pymol.pth").write venv.site_packages
  end

  def caveats
    "To generate movies, run `brew install ffmpeg`."
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from pymol import cmd
      cmd.fragment('ala')
      cmd.zoom()
      cmd.png("test.png", 200, 200)
    PYTHON

    system bin/"pymol", "-cq", testpath/"test.py"
    assert_path_exists testpath/"test.png", "Amino acid image should exist"
    system python3, "-c", "import pymol"
  end
end
