class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.7.tar.gz"
  sha256 "5a19eccca337da9e1cc629f2a223890af08987bc21771b9e860e28d823006be3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ffe716151403d7609bc171bd844d6c5563475e1ed9f92ee584239168a514e5aa"
    sha256 cellar: :any, arm64_sequoia: "204a970a56ce4f7415935e9e909493d374bbba8e1a2a798d0767f562ff56540f"
    sha256 cellar: :any, arm64_sonoma:  "bbf128e4f5f5411df300168940cca92bd0515a168b842b1b5bb9d73cfb329eba"
    sha256 cellar: :any, sonoma:        "949c46cc910ddfa2cd2f96ffb65b4aa8f0b5224b325be9d0752e3b01cd97a96b"
    sha256 cellar: :any, arm64_linux:   "388d905c0a75c17332d87c14f7745271ef15e5520c3645af14643ba811ec043f"
    sha256 cellar: :any, x86_64_linux:  "8aa3f814bb295dc0ff609d50d2bb308139f40157706d6697a47991e5856045b5"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
