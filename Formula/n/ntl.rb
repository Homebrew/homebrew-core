class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://libntl.org"
  url "https://libntl.org/ntl-11.6.0.tar.gz"
  sha256 "bc0ef9aceb075a6a0673ac8d8f47d5f8458c72fe806e4468fbd5d3daff056182"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://libntl.org/download.html"
    regex(/href=.*?ntl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d2f5f23855b76ee0a5d7d2e5dd4c85b2d40ab8ac76cfce653681e52398eef0b"
    sha256 cellar: :any,                 arm64_sequoia: "f86403426262a8c91d04b80ff2b642e68f220cf8e00a35cbebaf1fdb4c11f2f9"
    sha256 cellar: :any,                 arm64_sonoma:  "cbfb67228b7246561405a68553b4b433230cf913f43b677816c1e871ce43dd64"
    sha256 cellar: :any,                 sonoma:        "13c87c434a0b2c669fe2c2ce9909026b8f8a325fa3af3348bb5df3214d735383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f745b2c741b9c296092586bae7d8a0dfda2cd8bb74547caa6343957482f89a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "800477b02d398e95b1f820a5c3e100a9ea0f3f147bfbb1688a3c27f37eeae0e4"
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}", "SHARED=on"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<~CPP
      #include <iostream>
      #include <NTL/ZZ.h>

      int main()
      {
          NTL::ZZ a;
          std::cin >> a;
          std::cout << NTL::power(a, 2);
          return 0;
      }
    CPP
    gmp = Formula["gmp"]
    flags = %W[
      -std=c++11
      -I#{include}
      -L#{gmp.opt_lib}
      -L#{lib}
      -lntl
      -lgmp
      -lpthread
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end
