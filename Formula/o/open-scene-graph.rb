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
    sha256 arm64_tahoe:    "21caca227210b058d46d4817c12baef568b934d7ef6d8db034c3945af8986ae1"
    sha256 arm64_sequoia:  "6f82524b6c4bc107bc9d1acf481a2743670d2688130fa4ec16b568626773e39e"
    sha256 arm64_sonoma:   "971d66667cdd6f8a063a541b21d4b0f13318ada4223187ecf77c4c074db944a9"
    sha256 arm64_ventura:  "a061b2925b3d50c71102706eb8ccb68669df838cd4a716da8a1534003a55bc33"
    sha256 arm64_monterey: "cea275ac6fd59178f3d55ef6bf2ffedd5d8aab1431877007cba73d7844dc6091"
    sha256 arm64_big_sur:  "637623babd3324b945b39a4af706874c3f48420854e7b591e0df2ef0d1c77dc1"
    sha256 sonoma:         "3264ae2e7b588d9f48ee557fc00d95165f3a2c7c1262630d3fe4c74837e757ca"
    sha256 ventura:        "3fb06fe37e263b10478e97504eacbd3588dd50a845b3a4f8b280c43798ff67fb"
    sha256 monterey:       "2f2617969f263e4aa08b51fb64d9a7023c42e2d14e2c075a7a4602ba95a726f3"
    sha256 big_sur:        "95a78e9f79bdb83a94b9d9be412e4b4520f2467a2f55ea8479b494144175b2cf"
    sha256 catalina:       "1d38f6730fda72b85bdd25600cd415e747f5ade8645a6f4270d9e87dd275103e"
    sha256 arm64_linux:    "8dede4a58f246379ccea1fed1d9eb2392b99c3e837f216e8cda9fe25968eccfa"
    sha256 x86_64_linux:   "43c4367454e8de65443937a3509f96d4d273b50431b0a4fde16607c88183b247"
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
  uses_from_macos "zlib"

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
