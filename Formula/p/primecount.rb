class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.20.tar.gz"
  sha256 "a9d260b78b9c94c9c0347b3191ab748bc47c0b60114497b80f4290bc36cf9e76"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8274febe76ed6bc31480f91f4acd15e0958f1748d5e4fb599cd93d1ae5e709ba"
    sha256 cellar: :any,                 arm64_sequoia: "2f6ed227a05dbc8d620fa1715d7d4789fef81ac46ce655a0d6251c875a0868af"
    sha256 cellar: :any,                 arm64_sonoma:  "bcc6a6bb5514e53daa8a5acb6a9a47ef5f8197435d1e81ca2c3f26866e5a2f6e"
    sha256 cellar: :any,                 sonoma:        "d26abdeae8b66fb58d69cae5e64cfb1474d217ddb44ac5f3abe957deec9ec51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "037103e37c9278fcb57ad945bc9b5bec19d47b98d232b49e73633c046f921c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01616508a7eff07bd9f42903f02baf06821b28d0235ad47621a1ae208aee6991"
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
