class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.3.tar.gz"
  sha256 "c70bce5a41a27258bf0e3ad535d8238fb747d909a4b87ea14620f25dd65828fd"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "792e4fd9072bc8300a8005210760a0c0678e4d5afbc82ef0bedffbfb37ff4de3"
    sha256 cellar: :any,                 arm64_big_sur:  "67015c4202420ae239e94a7c1df5be67af65f5a717a965f581202557df639e04"
    sha256 cellar: :any,                 monterey:       "6bc15a550e9824e9e118c8b316cf29f752f7d1b4313f6a179a68988a2682f5c9"
    sha256 cellar: :any,                 big_sur:        "fbde141533f922dd195e69f432fef3d8fc3fa3234de841ae832e1513427ca528"
    sha256 cellar: :any,                 catalina:       "698edf1fd2794c4bf81e1debcddadf1fcad906f98cde53c7240705578ec3a584"
    sha256 cellar: :any,                 mojave:         "0cc57b006a581a0da50ef3b365f1cbd292e9ae054a552751cc7af3d93860ebce"
    sha256 cellar: :any,                 high_sierra:    "0a15741675e5c3f65f98fd89a25f0a1167294b95ba596620b63a45ad71dedea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d479472d9c8f7e3c5b0492e99b0682829bd6033c34e7817c571413760f7dce8"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DLIBTINS_ENABLE_CXX11=1"
      system "make", "install"
      doc.install "examples"
    end

    # Clean up the build file garbage that has been installed.
    rm_r Dir[share/"doc/libtins/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
