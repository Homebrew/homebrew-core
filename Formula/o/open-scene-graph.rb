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

  bottle do
    rebuild 2
    sha256               arm64_tahoe:   "98b12a674ce6d9934b3242ee26c7f19019e7b6d3f853270aac328069e5154dfd"
    sha256               arm64_sequoia: "581fe650587d4f4754ca98ef918c4d0ea5ade5511be34c59fbc4f0ac78f2d6d2"
    sha256               arm64_sonoma:  "39d01e3a2744d0883e813155f5147c3d2527a3b9627b89d21a49af8699bbd4d8"
    sha256               sonoma:        "6df520ae97f3f4483057f2a1700d3cad92f5bb58605e3f84af2999ae145e44ae"
    sha256               arm64_linux:   "c2ae7b0358fe9fd5828f69a7af80d061f642a96cdbe49b6580ed568045f484ae"
    sha256 cellar: :any, x86_64_linux:  "30c478b397a355079032f8837c093077fdafd9ad2becfd0c3e6703b25f24bf11"
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

      # Adding RPATH to hide `brew linkage` failure. Not using CMAKE_INSTALL_RPATH
      # to preserve upstream RPATH handling and to only add RPATH to plugins
      args += %W[
        -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{loader_path}/..
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
