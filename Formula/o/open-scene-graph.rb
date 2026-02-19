class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  license "LGPL-2.1-or-later" => { with: "WxWindows-exception-3.1" }
  revision 2
  head "https://github.com/openscenegraph/OpenSceneGraph.git", branch: "master"

  stable do
    url "https://github.com/openscenegraph/OpenSceneGraph/archive/refs/tags/OpenSceneGraph-3.6.5.tar.gz"
    sha256 "aea196550f02974d6d09291c5d83b51ca6a03b3767e234a8c0e21322927d1e12"

    # patch to fix build from source when asio library is present
    patch do
      url "https://github.com/openscenegraph/OpenSceneGraph/commit/21f5a0adfb57dc4c28b696e93beface45de28194.patch?full_index=1"
      sha256 "d1e4e33b50ab006420417c7998d7e0d43d0349e6f407b5eb92a3fc6636523fbf"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "e3174f80b6cec2585f35be266d182172c198b4ae8e0d10adf55e023d5d670b6c"
    sha256                               arm64_sequoia: "9b882e330c5007ae1ee55bbbd357aa19d48f3a6315aaf1e393e3100ab77cdba4"
    sha256                               arm64_sonoma:  "3403ff3e8a5135a92d60f30207ca12120b9463a92cb461e0f05e9f5a8192c0d2"
    sha256                               sonoma:        "40f22b2e52822a8497bd217b8e6f4911a85a5a687741aae2c1d4c7c9d7732861"
    sha256                               arm64_linux:   "b5ac9df2c542db731f565e9d13b4082c54976160e98ca3db80b23b57fb33dbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff70fc25d3113a46721cccb3498b4e21e90b81246d08bbb6f725c19b8a35c3d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "sdl2"

  uses_from_macos "curl"

  on_linux do
    depends_on "cairo"
    depends_on "giflib"
    depends_on "glib"
    depends_on "libpng"
    depends_on "librsvg"
    depends_on "libx11"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DBUILD_DOCUMENTATION=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_OpenEXR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_SDL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON
      -DCMAKE_CXX_FLAGS=-Wno-error=narrowing
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    if OS.mac?
      arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

      args += %W[
        -DCMAKE_OSX_ARCHITECTURES=#{arch}
        -DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio
        -DOSG_WINDOWING_SYSTEM=Cocoa
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "doc_openscenegraph"
    system "cmake", "--install", "build"

    doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <osg/Version>
      using namespace std;
      int main() {
          cout << osgGetVersion() << endl;
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-losg", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
