class MedFile < Formula
  desc "Modeling and Data Exchange standardized format library"
  homepage "http://www.salome-platform.org/"
  url "http://files.salome-platform.org/Salome/other/med-3.2.0.tar.gz"
  sha256 "d52e9a1bdd10f31aa154c34a5799b48d4266dc6b4a5ee05a9ceda525f2c6c138"

  depends_on "cmake" => :build
  depends_on "gcc" => :build   # for gfortan
  depends_on "swig" => :build
  depends_on "hdf5"
  depends_on "python"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/720fedf/med-file/libc%2B%2B_and_python_bindings_fixes.diff"
    sha256 "4125238ca3623e682b766cf2d34fed17938007ad326ae3b158a9cd427c638054"
  end

  def install
    python_prefix=`#{Formula["python"].opt_bin}/python2-config --prefix`.chomp
    python_include=Dir["#{python_prefix}/include/*"].first

    system "cmake", ".", "-DMEDFILE_BUILD_PYTHON=ON",
                         "-DMEDFILE_BUILD_TESTS=OFF",
                         "-DMEDFILE_INSTALL_DOC=ON",
                         "-DPYTHON_INCLUDE_DIR=#{python_include}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/medimport 2>&1", 255).chomp
    assert_match output, "Nombre de parametre incorrect : medimport filein [fileout]"
    (testpath/"test.c").write <<~EOS
      #include <med.h>
      int main() {
        med_int major, minor, release;
        return MEDlibraryNumVersion(&major, &minor, &release);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["hdf5"].opt_include}",
                   "-L#{lib}", "-lmedC", "-o", "test"
    system "./test"
  end
end
