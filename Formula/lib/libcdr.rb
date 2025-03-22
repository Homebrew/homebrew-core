class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.8.tar.xz"
  sha256 "ced677c8300b29c91d3004bb1dddf0b99761bf5544991c26c2ee8f427e87193c"
  license "MPL-2.0"
  revision 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c92d2906e9c17ed5a9e0a12541a9f57f9af90a159a8c415ac93f0849f1cf502b"
    sha256 cellar: :any,                 arm64_sonoma:  "78d0a8ac7a817bdf7fccecae5b1914bc2c54e6e42049277e3118b5ecb7a8a8a6"
    sha256 cellar: :any,                 arm64_ventura: "47f696438e82d0a76e5a9e571dc9805fffd5699e99cee039593cbea2797631da"
    sha256 cellar: :any,                 sonoma:        "d44ec2dbff4e7e9f375100722196a1d2598f494544da3324574fb807ff267cc8"
    sha256 cellar: :any,                 ventura:       "baebcf4d51a1ec8b9eb06eb5f08ed637604b54c62bfdf0a85d158e97656c824a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf43c9de53346d4c5916d81221c17d46af2a5b56688f279b560090c0d71ecf39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e3b5db26db8975d499f3838c57e8e62320f90cf4040297eebcf7799948afea7"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "librevenge"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  def install
    # icu4c 75+ needs C++17 and icu4c 76+ needs icu-uc
    # TODO: Remove after https://gerrit.libreoffice.org/c/libcdr/+/175709/1
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV["ICU_LIBS"] = "-L#{icu4c.opt_lib} -licui18n -licuuc"
    ENV.append "CXXFLAGS", "-std=gnu++17"

    system "./configure", "--disable-silent-rules",
                          "--disable-tests",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
