class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  license :cannot_represent
  revision 3
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  stable do
    url "https://github.com/schrodinger/pymol-open-source/archive/refs/tags/v3.1.0.tar.gz"
    sha256 "54306d65060bd58ed8b3dab1a8af521aeb4fd417871f15f463ff05ccb4e121fe"

    # Allow numpy 2+, remove on next release
    patch do
      url "https://github.com/schrodinger/pymol-open-source/commit/1b3aca8c053336fc5c7f72e79b4801f8fdd1af39.patch?full_index=1"
      sha256 "639261ff5b4d9c930ead3179cbbf64bf1e8fa575678561a0287c11f5a6cfa4d6"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "79544fccc4d17bd20141025aae92f35b17f88a5c1758ab78c89fcccf5615c14e"
    sha256 cellar: :any,                 arm64_sequoia: "665acb4efa21c515d5e6509db8fbaacc7e40ce859503a05035fe75a4f3f14000"
    sha256 cellar: :any,                 arm64_sonoma:  "a9abfeb724074d4d4f0db7ad04209ab03003b585c139d857a7bf13424c9b26c8"
    sha256 cellar: :any,                 sonoma:        "3c6324e63327d59aab594c97b560404d65808239706184dc5e06acdd703f82d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a338973b21416583937072cd7061b4aa3b6e08e68fe779dd8a3b4c9a598384a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c886c77fa66a6563c17e0f049af5528e269df4315b794b4b8951f6350135a525"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "msgpack-cxx" => :build
  depends_on "python-setuptools" => :build

  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "mesa"
  end

  resource "mmtf-cpp" do
    url "https://github.com/rcsb/mmtf-cpp/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "021173bdc1814b1d0541c4426277d39df2b629af53151999b137e015418f76c0"

    livecheck do
      url :url
    end
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

    ENV["PREFIX_PATH"] = "#{buildpath}/mmtf:#{ENV["CMAKE_PREFIX_PATH"]}"
    system python3, "-m", "pip", "install", "--config-settings=use-msgpackc=c++11", *std_pip_args, "."
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
