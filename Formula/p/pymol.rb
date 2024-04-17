class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "45e800a02680cec62dff7a0f92283f4be7978c13a02934a43ac6bb01f67622cf"
  license :cannot_represent
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a7d5ce7aa4499503bc07f0289fdd81cb324d700cafd4eb0e7e9cd0c772e38346"
    sha256 cellar: :any,                 arm64_ventura:  "06f74d35634668cfc8b10d9e9fb523ba24694280405ff08a52b8121c8e53015c"
    sha256 cellar: :any,                 arm64_monterey: "7b464dd70573ed1ac38c45784ad7813ac78c0ad83d48c10178725fe7d94f7110"
    sha256 cellar: :any,                 sonoma:         "f0e26bd61afef9e876b6e49a4096348e25865712d7a1a633f78c3bb3688aa11c"
    sha256 cellar: :any,                 ventura:        "67dc5f053f3cc16ede22371629fe7bae3a91651497f525f00439480ca1eaee40"
    sha256 cellar: :any,                 monterey:       "7a294c4309570b5b4be11df9ed830478867ab3964eedae04fe21e858c6a62918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b1b25827544632d7ec105e2e901b8ed9bd0a99e7b679691f292ceaa1980a51"
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
  depends_on "python-setuptools" # for pymol/plugins/installation.py
  depends_on "python@3.12"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "freeglut"
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

  def python3
    which("python3.12")
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
    (testpath/"test.py").write <<~EOS
      from pymol import cmd
      cmd.fragment('ala')
      cmd.zoom()
      cmd.png("test.png", 200, 200)
    EOS
    system "#{bin}/pymol", "-cq", testpath/"test.py"
    assert_predicate testpath/"test.png", :exist?, "Amino acid image should exist"
    system python3, "-c", "import pymol"
  end
end
