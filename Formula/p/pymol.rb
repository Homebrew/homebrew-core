class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "54306d65060bd58ed8b3dab1a8af521aeb4fd417871f15f463ff05ccb4e121fe"
  license :cannot_represent
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "3ee1fac3f4acfa49378b961e039ae07201634d853fcbd0df352b72f0fd5f442b"
    sha256 cellar: :any,                 arm64_ventura: "12a69a6eb48451e7030a5893caf3edca8ab8a5f43f145f6ad48cbdeab6eba387"
    sha256 cellar: :any,                 sonoma:        "f4e51d98c5be2c035a5225dfb7af2a0fe0ade4841e38fa31953108ab4b3b8d9c"
    sha256 cellar: :any,                 ventura:       "6b1c6d37c398ae95cc03502d7053f1a62c549101306ec7fd56b4216772a1535c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a9e125e347c9159dfa6e598fc200bdee34f1512e5d269c942f4fc64717b74c"
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
  depends_on "python@3.13"

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

  def python3
    which("python3.13")
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
