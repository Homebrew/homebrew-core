class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.9/c-ares-1.34.9.tar.gz"
  sha256 "9364b70a12eb59a06830fb488d9357f90100dff0d98b23ea3593a183d43e6f2f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4bbb881cf2c22728708e682a57f8c86fcd532f423be8d36a59b1500080f76820"
    sha256 cellar: :any, arm64_tahoe:       "b14c8350a3ce4e0ee7ee87fc679bfde9e3034e47a0fe1240fd42dcb1d6a134e9"
    sha256 cellar: :any, arm64_sequoia:     "ae8ba33a615c1738b0169d2f3f16f0d6b604bde0cd4fb05445c45c7b754d0636"
    sha256 cellar: :any, arm64_linux:       "a0c6f872457cc05cb819deeba731f7d0becd268b609f21f8395320dc487cf0c9"
    sha256 cellar: :any, x86_64_linux:      "294f16cb130751af8a596f93ff602004486b88f0417b45c2ba30be1372ba3d3a"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
