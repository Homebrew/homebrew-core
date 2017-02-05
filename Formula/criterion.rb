class Criterion < Formula
  desc "Dead-simple, non-intrusive unit testing framework for C and C++"
  homepage "http://criterion.readthedocs.io"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.3.0-1/criterion-v2.3.0-1.tar.bz2"
  version "2.3.0-1"
  sha256 "46a9473b7b35c5ffbb55927f1d9ad0d204dda3a6f0b8fea4003e2490e55619d5"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
                      "-DCMAKE_INSTALL_PREFIX=#{prefix}", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test_criterion.c").write <<-EOS.undent
      #include <criterion/criterion.h>

      Test(sample, test) {
        cr_assert(1);
      }
    EOS
    system ENV.cc, "test_criterion.c", "-lcriterion", "-o", "test_criterion"
    system "./test_criterion"
  end
end
