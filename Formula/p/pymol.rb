class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  license :cannot_represent
  revision 5
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  stable do
    url "https://github.com/schrodinger/pymol-open-source/archive/refs/tags/v3.1.0.tar.gz"
    sha256 "54306d65060bd58ed8b3dab1a8af521aeb4fd417871f15f463ff05ccb4e121fe"

    # Allow numpy 2+, remove on next release
    patch do
      url "https://github.com/schrodinger/pymol-open-source/commit/1b3aca8c053336fc5c7f72e79b4801f8fdd1af39.patch?full_index=1"
      sha256 "639261ff5b4d9c930ead3179cbbf64bf1e8fa575678561a0287c11f5a6cfa4d6"
      type :backport
      resolves "https://github.com/schrodinger/pymol-open-source/issues/428"
    end

    # Fix PyQt6 gesture enum compatibility, remove on next release
    patch do
      url "https://github.com/schrodinger/pymol-open-source/commit/6786f099c877c31cab1b18ad768e9b6c4aa6afab.patch?full_index=1"
      sha256 "d2ac61d66d92926c6dc8940563f546962b8b7d50c9b0c0b5532d898b8a33c175"
      type :backport
      resolves "https://github.com/schrodinger/pymol-open-source/issues/441"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1ab33e97cb4dcb0327a6cb948bc892508d44bacb3d081eac195e2f709167945"
    sha256 cellar: :any, arm64_tahoe:       "2cbac63edda32ec9a972b9ee2f44078a41a110988fb715b1a9fd22803f77048e"
    sha256 cellar: :any, arm64_sequoia:     "e1b1d9f6b903a69c91a8685b505c14dfe339e7e7de4444d77dfd1e949dd27112"
    sha256 cellar: :any, arm64_linux:       "5fb04a54730abaf561b8dbbfa2711c1c4e2016e115fad84ef6a24d549a67c23b"
    sha256 cellar: :any, x86_64_linux:      "daf8a0262938f3b8c67554b5082e32fbf6d386489c5e8ac80c50dffd5ec51c4d"
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
  depends_on "python@3.15"

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
