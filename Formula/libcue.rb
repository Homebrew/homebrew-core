class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/v2.2.1.tar.gz"
  sha256 "f27bc3ebb2e892cd9d32a7bee6d84576a60f955f29f748b9b487b173712f1200"

  bottle do
    cellar :any
    sha256 "88f893cd81af245a0f573cad9ddc4cbfddb1c8f948da7a01fd3218a32673626f" => :high_sierra
    sha256 "90efcf7400fece2beb2ce1a433331c87602fe6414dbbd09233c535dbb3d1d9a1" => :sierra
    sha256 "ccedc0b4aa350161a33a29241d250ef4cb3fab0f47a71c9cce19593edab62332" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
    (pkgshare/"tests").install Dir["t/*"]
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
