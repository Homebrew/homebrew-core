class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.18.1.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.18.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.18.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.18.1.tar.gz"
  sha256 "1a7d52a8a84a9fbffb1be9133c0f6e17217d91ea5a6fa61f6b4729cda78ebbcf"
  license "MIT"
  revision 1
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d033d01f5fb60bfdf8c13970b543dc22b5930133266d3bd251bddf808dd72aa4"
    sha256 cellar: :any,                 arm64_monterey: "a5818fef12f8028c1ee36d9df5213a74b8e3f33b08889043908bc59364cc29b5"
    sha256 cellar: :any,                 arm64_big_sur:  "2a3a10365f123633607a3569a8cb31afeac814229e17d975c95be5139f33fed5"
    sha256 cellar: :any,                 ventura:        "e0fce37577a8cd007314f96c2132e7c64ca5ee52f7a90ebeb8121eb7435f380e"
    sha256 cellar: :any,                 monterey:       "62b9590a3b9d30d2db8696da78948fb79a26c139536c3820c4275327fd808559"
    sha256 cellar: :any,                 big_sur:        "e276dddce0e43aba6e8f39b26be811294ae36cb7c45e203ff656bb52fa30242c"
    sha256 cellar: :any,                 catalina:       "3d1c10f0de6c0847e972f67e7e6021fde7ccc1f58dc5497182ae7af80bb127f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b66f4b75a81bd37ad1eebefc4a59e4ac41eb8d2d0f2b47f56a661366193dffc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system "#{bin}/ahost", "127.0.0.1"
  end
end
