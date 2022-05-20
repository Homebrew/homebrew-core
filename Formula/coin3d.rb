class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin) with Python bindings (Pivy)"
  homepage "https://coin3d.github.io/"
  license all_of: ["BSD-3-Clause", "ISC"]
  revision 3

  stable do
    url "https://github.com/coin3d/coin/archive/Coin-4.0.0.tar.gz"
    sha256 "b00d2a8e9d962397cf9bf0d9baa81bcecfbd16eef675a98c792f5cf49eb6e805"

    resource "pivy" do
      url "https://github.com/coin3d/pivy/archive/0.6.6.tar.gz"
      sha256 "27204574d894cc12aba5df5251770f731f326a3e7de4499e06b5f5809cc5659e"

      # Support Python 3.10.
      # Remove with the next version.
      patch do
        url "https://github.com/coin3d/pivy/commit/2f049c19200ab4a3a1e4740268450496c12359f9.patch?full_index=1"
        sha256 "4fcbe10b28aff1e20c2fd42ca393df7cc1bde59839f37f62d2b938831157d27b"
      end
      patch do
        url "https://github.com/coin3d/pivy/commit/4b919a3f6b9f477d0e95a2fd2b6a149a55eb9792.patch?full_index=1"
        sha256 "41107612702d9eec17d225d52f4b8b26a84d95492e418b265dc4c40284d595a3"
      end

      # Fix segmentation fault on Apple Silicon
      patch :DATA
    end
  end

  livecheck do
    url :stable
    regex(/^Coin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6e90d8890b3fb62e64c230cf6d18e8421cdfeb3f32566f53bd2922d695e30f43"
    sha256 cellar: :any, arm64_big_sur:  "52a07abdd5d902857a565c483dba9873b87e2b62ec76d22f0c7313bddce93b8f"
    sha256 cellar: :any, monterey:       "405ae02aa2ad54e90eaa4a027a293952dd8a275709a103eeb5660cfbb3660fdf"
    sha256 cellar: :any, big_sur:        "a549965ef49f10d7869ea3ff334d7872da6ea7c9c2251900212c2153db235cbf"
    sha256 cellar: :any, catalina:       "993bb8ae8ce7ad3e2622857e73a9a5af18e06b18cd34296f6c028d2a82872edc"
  end

  head do
    url "https://github.com/coin3d/coin.git"

    resource "pivy" do
      url "https://github.com/coin3d/pivy.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "pyside@2"
  depends_on "python@3.10"

  def install
    # Create an empty directory for cpack to make the build system
    # happy. This is a workaround for a build issue on upstream that
    # was fixed by commit be8e3d57aeb5b4df6abb52c5fa88666d48e7d7a0 but
    # hasn't made it to a release yet.
    mkdir "cpack.d" do
      touch "CMakeLists.txt"
    end

    mkdir "cmakebuild" do
      args = std_cmake_args + %w[
        -GNinja
        -DCOIN_BUILD_MAC_FRAMEWORK=OFF
        -DCOIN_BUILD_DOCUMENTATION=ON
        -DCOIN_BUILD_TESTS=OFF
      ]

      system "cmake", "..", *args
      system "ninja", "install"
    end

    resource("pivy").stage do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-rpath #{opt_lib}"
      system "python3", *Language::Python.setup_install_args(prefix),
                         "--install-lib=#{prefix/Language::Python.site_packages("python3")}"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", "-Wl,-framework,OpenGL", \
           "-o", "test"
    system "./test"

    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["pyside@2"].opt_lib}/python#{xy}/site-packages"
    system Formula["python@3.10"].opt_bin/"python3", "-c", <<~EOS
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end

__END__
diff --git a/interfaces/pivy_common_typemaps.i b/interfaces/pivy_common_typemaps.i
index 27e26a6..73162c0 100644
--- a/interfaces/pivy_common_typemaps.i
+++ b/interfaces/pivy_common_typemaps.i
@@ -76,7 +76,7 @@ SWIGEXPORT PyObject *
 cast(PyObject * self, PyObject * args)
 {
   char * type_name;
-  int type_len;
+  Py_ssize_t type_len;
   PyObject * obj = 0;
 
   if (!PyArg_ParseTuple(args, "Os#:cast", &obj, &type_name, &type_len)) {
