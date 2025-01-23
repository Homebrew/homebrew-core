class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "45e800a02680cec62dff7a0f92283f4be7978c13a02934a43ac6bb01f67622cf"
  license :cannot_represent
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "904c051cb45e268db9779fdad63d78be5fdf06e9e27b232226539ea1b705a456"
    sha256 cellar: :any,                 arm64_sonoma:  "8833b94cf1eeac4270c8493a45cf7834f8f504d2fa7035797eff676aa82848b8"
    sha256 cellar: :any,                 arm64_ventura: "a36682e5f1db804e7c5b4b2f2a9e62d555e9651b25b3c3afe5d62f0f7af7c6c1"
    sha256 cellar: :any,                 sonoma:        "a92d1debd4a4c78fe3d71e3ea29c4a074e8be8d06178b61b306521d31cdb1fbc"
    sha256 cellar: :any,                 ventura:       "b32a2ef527361c088669ed0dacccc16c25b0040a3f54613337ecc3ea58603f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233778acd8b74666d8b104390355f5657b47dd87007ee2c13a2b83710cecd4dd"
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
  depends_on "pyqt@5"
  depends_on "python@3.13"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
  end

  resource "mmtf-cpp" do
    url "https://github.com/rcsb/mmtf-cpp/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "021173bdc1814b1d0541c4426277d39df2b629af53151999b137e015418f76c0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "mmtf-python" do
    url "https://files.pythonhosted.org/packages/d8/0f/f3c132dc9aac9a3f32a0eba7a80f07d14e7624e96f9245eeac5fe48f42cd/mmtf-python-1.1.3.tar.gz"
    sha256 "12a02fe1b7131f0a2b8ce45b46f1e0cdd28b9818fe4499554c26884987ea0c32"
  end

  resource "pmw" do
    url "https://github.com/schrodinger/pmw-patched/archive/8bedfc8747e7757c1048bc5e11899d1163717a43.tar.gz"
    sha256 "3a59e6d33857733d0a8ff0c968140b8728f8e27aaa51306160ae6ab13cea26d3"
  end

  # Drop distutils: https://github.com/schrodinger/pymol-open-source/pull/362
  patch do
    url "https://github.com/schrodinger/pymol-open-source/commit/4d81b4a8537421e9a1c4647934d1a16e24bc51dd.patch?full_index=1"
    sha256 "ee5895ecd3bf731fc1ad714cc6cea17cb5dbb81cd4dab62e77554219fe7ae1ec"
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

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "mmtf-cpp" }

    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.append_path "PREFIX_PATH", buildpath/"mmtf"
    ENV.append_path "PREFIX_PATH", Formula["freetype"].opt_prefix
    ENV.append_path "PREFIX_PATH", Formula["libxml2"].opt_prefix if OS.linux?
    ENV["PIP_CONFIG_SETTINGS"] = "--build-option=--glut --use-msgpackc=c++11"
    # setup.py incorrectly handles --install-lib='' set by bdist_wheel
    inreplace "setup.py", "self.install_libbase", "'#{venv.site_packages}'"
    venv.pip_install_and_link buildpath

    (prefix/site_packages/"homebrew-pymol.pth").write venv.site_packages
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
    assert_predicate testpath/"test.png", :exist?, "Amino acid image should exist"
    system python3, "-c", "import pymol"
  end
end
