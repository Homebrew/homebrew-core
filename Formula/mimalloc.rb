class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  # 2.x series is in beta and shouldn't be upgraded to until it's stable
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "d74f86ada2329016068bc5a243268f1f555edd620b6a7d6ce89295e7d6cf18da"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a600ddfb26f682c065638cf21d0a42247d31ac33a27ca525501b0c11645f73f3"
    sha256 cellar: :any,                 arm64_big_sur:  "34179acc2bfaf5e8b45cb3d0ba5ce34d8f10707cace446ccf24c3f456964f775"
    sha256 cellar: :any,                 monterey:       "16f7d8b1f61a463cce7ebebb368587173ee72e82a1e82b468144dff2a6d20c82"
    sha256 cellar: :any,                 big_sur:        "35cb0ef636188ee92d2a5aa63d8e1ca422f3b7962daba961bb25845c27aab028"
    sha256 cellar: :any,                 catalina:       "caa9ca85b45b5055eb0b2dcfd191c3cafd3cd9ff02c6714d46987ac49e3bda55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48f4d9a37d46c4289fdcbea078567975e59b40c6a3f4fa1d275b31185d43401b"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DMI_INSTALL_TOPLEVEL=ON"
      system "make"
      system "make", "install"
    end
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
