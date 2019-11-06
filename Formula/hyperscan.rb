class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.2.1.tar.gz"
  sha256 "fd879e4ee5ecdd125e3a79ef040886978ae8f1203832d5a3f050c48f17eec867"

  bottle do
    cellar :any
    sha256 "cacfe36f25b46fe2471198bc6681eb194a3fd256cde11ed83d981c2460ac8b82" => :catalina
    sha256 "ac6af77275747fbf4b9ae3f311512c7370a8f89b34dfc7c871d4dc7807ec2e74" => :mojave
    sha256 "3cd0c873c95437297f7a8939ada2d1f7094f63616684d548c23eb9293c1cd098" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ragel" => :build
  depends_on "pcre"

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
