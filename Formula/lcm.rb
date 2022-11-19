class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  license "LGPL-2.1"
  revision 7
  head "https://github.com/lcm-proj/lcm.git", branch: "master"

  stable do
    url "https://github.com/lcm-proj/lcm/releases/download/v1.4.0/lcm-1.4.0.zip"
    sha256 "e249d7be0b8da35df8931899c4a332231aedaeb43238741ae66dc9baf4c3d186"

    # Fix compatibility with Python 3.11. Remove in the next release
    # .../lcm-python/module.c:46:34: error: expression is not assignable
    #     Py_TYPE(&pylcmeventlog_type) = &PyType_Type;
    patch do
      url "https://github.com/lcm-proj/lcm/commit/0289aa9efdf043dd69d65b7d01273e8108dd79f7.patch?full_index=1"
      sha256 "c20661ed66e917e90f8130c0f54139250203e42b62e910e15c0b3998432304b7"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "386e950921eba82b38394b42e31fccaa778922b1d069d9f79ccec9574d721fca"
    sha256 cellar: :any,                 arm64_monterey: "43909fa2e1f9a714d4c8dd89776aa3781860242caeb4ffa8fecea7fa483401a6"
    sha256 cellar: :any,                 arm64_big_sur:  "edb01154939c091081d063b46ee1d1c0c66f2df50faf15902ec5cada1a5ef0b8"
    sha256 cellar: :any,                 monterey:       "1758d440848cb30faea78cd2fe83adb3ebd1cd4397fda48ab69484ad4c2d0d40"
    sha256 cellar: :any,                 big_sur:        "253ad14044e332543f5857fb1ff33e81812fa01a539c204fa0189796a2ce60df"
    sha256 cellar: :any,                 catalina:       "1968fc2e98dbb67e409caaf101bb1e13662f15748d6b887c274d68d4a08265cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a0f9a8ab26a721fb3be823187eee4ad9f49a49c28e1020808dd69d18977707b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"
  depends_on "openjdk"
  depends_on "python@3.11"

  def install
    # Adding RPATH in #{lib}/lua/X.Y/lcm.so and some #{bin}/*.
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DLCM_ENABLE_EXAMPLES=OFF
      -DLCM_ENABLE_TESTS=OFF
      -DLCM_JAVA_TARGET_VERSION=8
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;
      struct example_t {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system bin/"lcm-gen", "-c", "example_t.lcm"
    assert_predicate testpath/"exlcm_example_t.h", :exist?, "lcm-gen did not generate C header file"
    assert_predicate testpath/"exlcm_example_t.c", :exist?, "lcm-gen did not generate C source file"
    system bin/"lcm-gen", "-x", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.hpp", :exist?, "lcm-gen did not generate C++ header file"
    system bin/"lcm-gen", "-j", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate Java source file"
    system bin/"lcm-gen", "-p", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.py", :exist?, "lcm-gen did not generate Python source file"
  end
end
