class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.16.1.tar.gz"
  sha256 "d08312d0ecc3bd48eee0a4cc0d2137c9f194e0a28de2028928c0f6cae85f86ce"
  license "MIT"
  revision 1
  head "https://github.com/bagder/c-ares.git"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "72a7232d82c7601576bd2af4271157ee34ff478f1cd7febe5c144254ec5e9e07" => :catalina
    sha256 "cd4a1354a3658e804caf1b24a33a40078948d3f9ed9413cb4f32e56045ef244d" => :mojave
    sha256 "14b1bbb8bced1bde8b3a8beb5e3e35fcb65a1dec45393c37cc0533f67d41ec8b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
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
  end
end
