class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.4.tar.gz"
  sha256 "c7bf47c041bfe4c3912a0d503ea44c1bb6c9003427c12574a6b497748b387612"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2f6ac92bcaa736b8414858a9ebc856c3418a69e3c90434fe6c309a521890407"
    sha256 cellar: :any,                 arm64_sequoia: "0dff8ce3b61cc644e23204b554e025f63cce8ae1550bd2cb1c05febc9a2b75c7"
    sha256 cellar: :any,                 arm64_sonoma:  "41b2daae672ef831730f1cdd80ea7cb66a160592337f981bbaa600bfd7a4b821"
    sha256 cellar: :any,                 sonoma:        "aaa36894f1d178c90903e920a77b199479cb90ef6b54baf42b7fa4b240dd2b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6bd0e22856270c66e3c6ba47dcfab3accd5fd1ff7aedd0c2f65fbe7588df2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181deedaece6b18c7c70ab7c733a8f03a831d145f68c51e720fcf201efdc0e82"
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
