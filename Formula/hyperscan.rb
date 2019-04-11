class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.1.1.tar.gz"
  sha256 "e3bb509d4002f2d75e1804e754efa6334316d1ee110a3b85c8156c08fe5e2369"

  bottle do
    cellar :any
    sha256 "724e189eba53847758564440c7d648503ab241abdefd8a67814f75060c119873" => :mojave
    sha256 "c496461231e9261012665f5632e38016747eef826c08a2280a4ea1201eebd303" => :high_sierra
    sha256 "4b3abe7a19dad7770dd1168d0bcf8a139b325d3c7e9582a446486e16a23935a4" => :sierra
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
