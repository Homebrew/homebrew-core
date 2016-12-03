class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/v2.1.0.tar.gz"
  sha256 "288ddd01e5f9e8f901d0c205d31507e4bdffd2540fa86073f2fe82de066d2abb"

  bottle do
    cellar :any
    rebuild 2
    sha256 "1364a393179776e3deedce880702d4c9ce425eb3b9ab84e016809c1e234e9749" => :sierra
    sha256 "420574b32e8adcca07f13a7727b4f2d3391b91566aa7fad63b452cd11fc881ad" => :el_capitan
    sha256 "1734b330e87a099d8a0c472af86e3f1c1babfabb3d29240a74e54e98932c91af" => :yosemite
    sha256 "f61624f74ef918f2b90bdfc9157f7a08829153dd2655ad73126e0a0ddd60127d" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    (pkgshare/"tests").mkpath
    cp_r "t/.", pkgshare/"tests"
    system "make", "test"
    system "make", "install"
  end

  test do
    cp_r (pkgshare/"tests").children, testpath
    Dir["*.c"].each do |f|
      system ENV.cc, f, "-o", "test", "-L#{lib}", "-lcue", "-I#{include}"
      system "./test"
      rm "test"
    end
  end
end
