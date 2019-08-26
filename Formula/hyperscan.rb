class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.2.0.tar.gz"
  sha256 "bb02118efe7e93df5fc24296406dfd0c1fa597176e0c211667152cd4e89d9d85"

  bottle do
    cellar :any
    sha256 "eb3598a0cc81779744de90bed42c6fcd4b0a00178e30addeaef875b9f512393e" => :mojave
    sha256 "d5f4957952f9ee837b50e81cb9c58f6d8889d9df823a91ca9c9418230b7093bf" => :high_sierra
    sha256 "c7a0dc597b4bf6c4c162c4d0ad2827a8b243d949035d9e1dd05680bce0d17d1b" => :sierra
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
