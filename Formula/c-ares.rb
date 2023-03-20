class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.19.0.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.19.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.19.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.19.0.tar.gz"
  sha256 "bfceba37e23fd531293829002cac0401ef49a6dc55923f7f92236585b7ad1dd3"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "509c92f0a1814475b0f9635923d2a895d2b2e00d0360d7dbf5e94f9625d09b15"
    sha256 cellar: :any,                 arm64_monterey: "1fc78eca07e024e86100c49645ab4e31e994a1d8c601d0373fcea0980ba92ffc"
    sha256 cellar: :any,                 arm64_big_sur:  "537a7aea3bbae0b6380ea608e648bcbe9591fc5e02f19dabb307d2d3cf330139"
    sha256 cellar: :any,                 ventura:        "0830e352c2b4ee35920c8f8729b62bae6d6b22413b8209fd687a07b0e08b396d"
    sha256 cellar: :any,                 monterey:       "b139bac5959fe35d704520ce0409578b1cea4c4e1f49510c4db6800d4d304952"
    sha256 cellar: :any,                 big_sur:        "7d5bf9ffd0c47eb9a0f5cc56cccdca52e631595ea00833a3ccd3be7adde54d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35460bcc5ba465569d515ea2773e270951749500e493622d19c3d2151e8113ae"
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
