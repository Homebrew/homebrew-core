class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  license "MIT"
  revision 1

  # TODO: Switch to `glbinding` with v2 release and remove stable/head blocks.
  # Also consider deprecating `glbinding@2` based on upstream support status.
  stable do
    url "https://github.com/cginternals/globjects/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "68fa218c1478c09b555e44f2209a066b28be025312e0bab6e3a0b142a01ebbc6"
    depends_on "glbinding@2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85b4f1d5eb729806747d7590376b8a4803615e12b1020f857ed953bc26e90438"
    sha256 cellar: :any,                 arm64_ventura:  "8ff9f80163b64a4737dc2d0e0e28002d55194091d5c2d9cdb361cf02661778d4"
    sha256 cellar: :any,                 arm64_monterey: "6b91d3162b931f8964893b23126b8d337ccfd3ef0d7b9ab889b1d65601541bd7"
    sha256 cellar: :any,                 sonoma:         "275eaa25310c701e9ba4e1022b1b9bdadf3bdb64cf6a86ae77298523d152329c"
    sha256 cellar: :any,                 ventura:        "4c43449656c4dcc9a7f2b355632daba1cbd002d6ad45f54d502ae372d74bffa9"
    sha256 cellar: :any,                 monterey:       "046dc6b5271eec1551fd899bca30036981fb8ca95edc02a342ea0ec0a87313d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb290699d5ea7fa3ab29b1d53ffcb2ad1580115b04258cd237e26a4f3e2a717"
  end

  head do
    url "https://github.com/cginternals/globjects.git", branch: "master"
    depends_on "glbinding"
  end

  depends_on "cmake" => :build
  depends_on "glm"

  def install
    # Force install to use system directory structure as the upstream only
    # considers /usr and /usr/local to be valid for a system installation
    inreplace "CMakeLists.txt", "set(SYSTEM_DIR_INSTALL FALSE)", "set(SYSTEM_DIR_INSTALL TRUE)"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <globjects/globjects.h>
      int main(void)
      {
        globjects::init();
      }
    EOS
    flags = ["-std=c++11"]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cxx, "-o", "test", "test.cpp", *flags,
                    "-I#{include}/globjects",
                    "-I#{Formula["glbinding@2"].opt_include}",
                    "-I#{Formula["glm"].opt_include}/glm",
                    "-L#{lib}", "-L#{Formula["glbinding@2"].opt_lib}",
                    "-lglobjects", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
