class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  revision 1
  head "https://github.com/doxygen/doxygen.git"

  stable do
    url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.13.src.tar.gz"
    sha256 "af667887bd7a87dc0dbf9ac8d86c96b552dfb8ca9c790ed1cbffaa6131573f6b"

    # Remove for > 1.8.13
    # "Bug 776791 - [1.8.13 Regression] Segfault building the breathe docs"
    # Upstream PR from 4 Jan 2017 https://github.com/doxygen/doxygen/pull/555
    patch do
      url "https://github.com/doxygen/doxygen/commit/0f02761.patch"
      sha256 "2c3d700c3a7c191ef432099db30abc3360c021d3a3dd1836440385dde8a1c264"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3b7ce08e77be402eaf00af186b42b1d2fd97f24a6ad22d36a259841f2886aba1" => :sierra
    sha256 "be3f7f84ddb5bd4067883d9cf29c021371d62f9257fa1671474eccb45ee2622e" => :el_capitan
    sha256 "21032e3ea21e9de98c1b038391e5c21e0c11f309ee77a34d26466bf83de5adb5" => :yosemite
  end

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"
  deprecated_option "with-doxywizard" => "with-qt"
  deprecated_option "with-libclang" => "with-llvm"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt" => :optional
  depends_on "llvm" => :optional

  def install
    args = std_cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}"
    args << "-Dbuild_wizard=ON" if build.with? "qt"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "llvm"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
