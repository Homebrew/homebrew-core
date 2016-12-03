class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/v2.1.0.tar.gz"
  sha256 "288ddd01e5f9e8f901d0c205d31507e4bdffd2540fa86073f2fe82de066d2abb"

  bottle do
    cellar :any
    sha256 "36aa09e84bcd5c561ebe75d4357e1f5c4702bdec20b706ad97ed09b5aabf15f5" => :sierra
    sha256 "82b0f3b0ae9f85046e495fc4405e93128a4d4118fcbb46dff8941d76d8c35335" => :el_capitan
    sha256 "73393d9546784ef457fc2659918c5b46e2f3cdbe61707d2a8cf2a997ec2e5246" => :yosemite
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
