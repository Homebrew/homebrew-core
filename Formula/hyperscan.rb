class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.2.0.tar.gz"
  sha256 "bb02118efe7e93df5fc24296406dfd0c1fa597176e0c211667152cd4e89d9d85"

  bottle do
    cellar :any
    sha256 "43011c1b22b77a1b0e4772fd77f926356cc2375e0bda3f31599fdc2d06bf544a" => :mojave
    sha256 "9e37390d7cb7363c24c8408681b8a09577cdeb23741ff62d5eaf54d79c3e341a" => :high_sierra
    sha256 "81466315c420233e06f1f1593631b063bf001296fe74ed810cb48fe984cabb08" => :sierra
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
