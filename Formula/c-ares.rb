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
    sha256 "0ba43741f90d2529cf03785faf077ee38898124474bd147718ed8a9ccf0f68a5" => :catalina
    sha256 "5c144152a0ea9ce016043fc37b6f456f9a8270298432d5283c52ec3676c70b3c" => :mojave
    sha256 "a2761fa50d7e565997a8c1f5fffdad4ad439b5f5245852b5bf6c431b85fe447a" => :high_sierra
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
