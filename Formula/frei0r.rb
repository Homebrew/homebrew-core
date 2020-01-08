class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.7.0.tar.gz"
  sha256 "1b1ff8f0f9bc23eed724e94e9a7c1d8f0244bfe33424bb4fe68e6460c088523a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5076041b5f3d76b94866ab2b97ad34523ee40cfa314e6f7d2bf460ce304de872" => :catalina
    sha256 "5e23b93a7ff4a2ee64c5a969b17bf6a52329e6da17c0612b46aa2ceec3fb5b39" => :mojave
    sha256 "a6a4648e1ff6263616f532a4648e1eb56e68d510d04e768becb2caf5ca961e3a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""
    cmake_args = std_cmake_args + %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
