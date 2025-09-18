class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/refs/tags/releases/0.108.11.tar.gz"
  sha256 "1063b6a057e80222e2ede3ef0c73c0c54697e0fee1d913e2bef530310c13a670"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^releases/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cba7ab1ccf3bfe814eef30dfe9def0b9ff44a29a31e93efbcdef050174d08f5b"
    sha256 cellar: :any,                 arm64_sequoia:  "d481d371981a212968f123ab295b4a2f891040f411dfa9cbf6b537adc851c155"
    sha256 cellar: :any,                 arm64_sonoma:   "92e1f220abefbedf5afa236f48941731101b6bc6cf3c0a5a3a42c4ded4af2a58"
    sha256 cellar: :any,                 arm64_ventura:  "62ff3b164a73eb23614ab0bf0ae1fcca5bb41e83fd64ebccb8f245cc5aa23c0c"
    sha256 cellar: :any,                 arm64_monterey: "ab536eb79add604baa066582abcda1ad72018ce2aa1e74144d11d4a4988ad259"
    sha256 cellar: :any,                 sonoma:         "c24c4a4d44b819fa097e9b3f77602f8d21175a1ca94199933396ffb334575306"
    sha256 cellar: :any,                 ventura:        "d83b00f27e81af9188cc1066ec87b0375c3c8dcc32c71d2ea6a89aacae006003"
    sha256 cellar: :any,                 monterey:       "d05eb1c3f01d1687b03107578ed1054bfb34424c2b388a0b5c98cd2bcc0e442b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "215b27d8b21a6756ec8174cebb1e8e9c2f0a2769bee7fef39b95630f7b67cb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "093a334ad180ed10951e23866b1d6df68087fc29aee54a749899bb8b5d629780"
  end

  depends_on "pkgconf" => :build
  depends_on "coinutils"

  on_macos do
    depends_on "openblas"
  end

  def install
    # Work around - same as clp formula
    # Error 1: "mkdir: #{include}/osi/coin: File exists."
    mkdir include/"osi/coin"

    system "./configure", "--disable-silent-rules", "--includedir=#{include}/osi", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <OsiSolverInterface.hpp>

      int main() {
        OsiSolverInterface *si;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lOsi",
                    "-I#{include}/osi/coin",
                    "-I#{Formula["coinutils"].include}/coinutils/coin",
                    "-o", "test"
    system "./test"
  end
end
