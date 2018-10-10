class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.0.0.tar.gz"
  sha256 "f2bdebff62a2fc0b974b309da7be4959869fb7cababe1169b7693cfd672c2fe0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9a4ae35b756b62b885018d1666f25b7ebdd700708a3c9dfff296a7c383d4f7be" => :mojave
    sha256 "4eb9cb28a8a13cdf02831b940c4b833f10119005fa531c6be5c1c734e8f5495b" => :high_sierra
    sha256 "ea325f93c7bb9ef06b9c5de2fb30a0d369fda33fc12c9a9a54d1640ef06e8dca" => :sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ragel" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_STATIC_AND_SHARED=on"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
