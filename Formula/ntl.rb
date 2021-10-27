class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://libntl.org"
  url "https://libntl.org/ntl-11.5.1.tar.gz"
  sha256 "210d06c31306cbc6eaf6814453c56c776d9d8e8df36d74eb306f6a523d1c6a8a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://libntl.org/download.html"
    regex(/href=.*?ntl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2bd16013e5715eefa223b3a72a08e725e2414a2d0b849199a253aef506ee9ba2"
    sha256 cellar: :any,                 arm64_big_sur:  "972f6f6fdf45e71f8d852a5ab162189f14bb1f800692af4466b5672e75ff62cd"
    sha256 cellar: :any,                 monterey:       "d882847db4da92801d989382e682e6ba372263942ef42eafdd16e2672cdeb107"
    sha256 cellar: :any,                 big_sur:        "e108c06f39537cdc58cd6e7f681395ae069c381af5e0c95abca97d1ccc90ec9e"
    sha256 cellar: :any,                 catalina:       "b97739b3b8de3daabe0d76cec3e29ef47f4bc85e6197054aec6d10f6b8f1a4ae"
    sha256 cellar: :any,                 mojave:         "bc2ffa687c16e3ee99c093dc0b55275df08c278e20c1d2281e798f1144816634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0612d19a82889b93ddae2920ccd148644bee62f74c0c39662c20bb8447fe6c2"
  end

  depends_on "gmp"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "src/libtool-origin"
  end

  def install
    args = ["PREFIX=#{prefix}", "SHARED=on"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<~EOS
      #include <iostream>
      #include <NTL/ZZ.h>

      int main()
      {
          NTL::ZZ a;
          std::cin >> a;
          std::cout << NTL::power(a, 2);
          return 0;
      }
    EOS
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
