class Assetkit < Formula
  desc "Fast 3D asset import/export library and command-line converter"
  homepage "https://github.com/recp/assetkit"
  url "https://github.com/recp/assetkit/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "325b3c98b9a7fac4652bebaf6ebca71b6299973661121e95474fdc9dc3898e88"
  license "Apache-2.0"
  head "https://github.com/recp/assetkit.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "cglm"
  depends_on "draco"
  depends_on "zstd"
  uses_from_macos "zlib"

  resource "ds" do
    url "https://github.com/recp/libds/archive/6bd7d96bc7a758893299789f9b34b87782d3f4c9.tar.gz"
    sha256 "b8b8dff934cda8fe4016ef97c727b00ce16f2003189a0831c6462696f796be5b"
  end

  resource "json" do
    url "https://github.com/recp/json/archive/c69befd5996e29412bc2b705732f6508da19950f.tar.gz"
    sha256 "742d905c05b82ad58d71068e8f2d112c27e323d8213c3d80019c2e84de96ef1c"
  end

  resource "xml" do
    url "https://github.com/recp/xml/archive/4289c02cda9a73a8e11137279a6dc6e9347adee3.tar.gz"
    sha256 "041f9e01c2ceec22b650c11bd9f96410a54e3561a4a745f1d9eb1c9a877e5f7f"
  end

  resource "meshoptimizer" do
    url "https://github.com/zeux/meshoptimizer/archive/refs/tags/v1.1.1.tar.gz"
    sha256 "30cd4d28fe71bf58c614c23c87fed385bac223acbb2dfaf343d20ffc3584a083"
  end

  resource "spz" do
    url "https://github.com/nianticlabs/spz/archive/bb0efadae5963f8a11ace3202ba6de6b1631318e.tar.gz"
    sha256 "f79412de0296c4e12c219f72b4fb9a8ffd157c76ef483997bc41f91aaef520d1"
  end

  resource "ktx-software" do
    url "https://github.com/KhronosGroup/KTX-Software/archive/refs/tags/v4.4.2.tar.gz"
    sha256 "9412cb45045a503005acd47d98f9e8b47154634a50b4df21e17a1dfa8971d323"
  end

  def install
    %w[ds json xml meshoptimizer].each do |dep|
      dep_path = buildpath/"deps/#{dep}"
      rm_r dep_path if dep_path.exist?
    end

    resource("ds").stage buildpath/"deps/ds"
    resource("json").stage buildpath/"deps/json"
    resource("xml").stage buildpath/"deps/xml"
    resource("meshoptimizer").stage buildpath/"deps/meshoptimizer"

    spz_prefix = buildpath/"vendor/spz"
    resource("spz").stage buildpath/"vendor-src/spz"
    system "cmake", "-S", buildpath/"vendor-src/spz", "-B", "build-spz", "-G", "Ninja",
           "-DSPZ_BUILD_TOOLS=OFF",
           "-DSPZ_BUILD_PYTHON_BINDINGS=OFF",
           "-DSPZ_BUILD_EXTENSIONS=OFF",
           "-DBUILD_SHARED_LIBS=OFF",
           *std_cmake_args(install_prefix: spz_prefix)
    system "cmake", "--build", "build-spz"
    system "cmake", "--install", "build-spz"

    ktx_prefix = buildpath/"vendor/ktx"
    resource("ktx-software").stage buildpath/"vendor-src/ktx"
    system "cmake", "-S", buildpath/"vendor-src/ktx", "-B", "build-ktx", "-G", "Ninja",
           "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
           "-DKTX_FEATURE_TESTS=OFF",
           "-DKTX_FEATURE_TOOLS=OFF",
           "-DKTX_FEATURE_DOC=OFF",
           "-DKTX_FEATURE_LOADTEST_APPS=OFF",
           "-DBUILD_SHARED_LIBS=OFF",
           *std_cmake_args(install_prefix: ktx_prefix)
    system "cmake", "--build", "build-ktx"
    system "cmake", "--install", "build-ktx"

    args = %w[
      -DAK_BUILD_CLI=ON
      -DAK_BUILD_CLI_STATIC=OFF
      -DAK_BUILD_DECODER_SHIMS=ON
      -DAK_FETCH_DEPS=OFF
      -DAK_STATIC_INTERNAL_DEPS=ON
      -DAK_USE_SYSTEM_CGLM=ON
      -DAK_USE_TEST=OFF
      -DAK_BUILD_TOOLS=OFF
      -DAK_BUILD_SAMPLES=OFF
    ]
    args += %W[
      -DAK_CGLM_ROOT=#{formula_opt_prefix("cglm")}
      -DAK_DRACO_ROOT=#{formula_opt_prefix("draco")}
      -DAK_MESHOPT_ROOT=#{buildpath}/deps/meshoptimizer
      -DAK_SPZ_ROOT=#{spz_prefix}
      -DAK_KTX2_ROOT=#{ktx_prefix}
    ]

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm lib/"libds.a"
    rm_r include/"ds"
    rm_r lib/"cmake/ds"
  end

  test do
    (testpath/"pyramid.obj").write <<~OBJ
      o Pyramid
      v -0.5 0.0 0.5
      v 0.5 0.0 0.5
      v 0.5 0.0 -0.5
      v -0.5 0.0 -0.5
      v 0.0 1.0 0.0
      f 4 3 2 1
      f 1 2 5
      f 2 3 5
      f 3 4 5
      f 4 1 5
    OBJ

    inspect = shell_output("#{bin}/assetkit --inspect pyramid.obj")
    assert_match "format: obj", inspect
    assert_match "geometries: 1", inspect

    system bin/"assetkit", "--convert", "pyramid.obj", "pyramid.ply"
    assert_path_exists testpath/"pyramid.ply"
    assert_equal "ply", (testpath/"pyramid.ply").binread(3)

    (testpath/"test.c").write <<~C
      #include <ak/assetkit.h>

      int main(int argc, char **argv) {
        AkDoc *doc = 0;
        AkResult result;

        if (argc != 2)
          return 2;

        result = ak_load(&doc, argv[1], AK_FILE_TYPE_AUTO);
        if (result != AK_OK || !doc)
          return 1;

        ak_free(doc);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
           "-Wl,-rpath,#{lib}", "-lassetkit", "-o", "test"
    system "./test", "pyramid.obj"
  end
end
