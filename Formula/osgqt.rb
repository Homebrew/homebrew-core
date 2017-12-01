class Osgqt < Formula
  desc "Use OpenSceneGraph inside your Qt applications"
  homepage "https://github.com/openscenegraph/osgQt"
  url "https://github.com/openscenegraph/osgQt/archive/3.5.7.tar.gz"
  sha256 "dcc4436590639168e6470fe9c5343c82bca738d3296ebee014f40f2dc029afa1"

  option "with-docs", "Build the documentation with Doxygen"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "open-scene-graph"
  depends_on "qt"

  depends_on "doxygen" => :build if build.with? "docs"

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=" + (build.with?("docs") ? "ON" : "OFF")

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_32_bit}"
    end

    args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"] if build.with? "docs"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <osg/Version>

      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{Formula["open-scene-graph"].opt_lib}/", "-losg", "-L#{lib}", "-losgqt", "-o", "test"
    system "./test"
  end
end
