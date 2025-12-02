class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "05c87f2b50d4774e16868ba61a7271930dd67f4ad137f30eb0f310969377bc20"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "803815f7a62fe41c3af529f91c0c5dec64562c76a9ed3c3af559f666e554a0a3"
    sha256 cellar: :any,                 arm64_sequoia: "f9bbc95593524143828d00e06eaea405c7721b737811f782cd7d906b21c2fa0b"
    sha256 cellar: :any,                 arm64_sonoma:  "71661a64a50f6f5bcc7d4cb9f779141f5cfed6fcfbeb1193a21d18c545aa37bc"
    sha256 cellar: :any,                 sonoma:        "9da3101e6e55c978f00a9fc877a13ba5289ea18857ac5fe8fba073003ae61601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6145938664a747795370be1a28c3a06f586c02faf893053bd89c8507e47242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f2e649e6834f35404942593f0ad42da062d8bbadd314f05570d72a14b0dc3a"
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "gmp"
  depends_on "ntl"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_country_db_lookup/BGV_country_db_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-pthread", "-lhelib", "-lntl", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end
