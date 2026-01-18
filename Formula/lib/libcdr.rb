class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.8.tar.xz"
  sha256 "ced677c8300b29c91d3004bb1dddf0b99761bf5544991c26c2ee8f427e87193c"
  license "MPL-2.0"
  revision 2

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1a695c949efb8d7f2e380a8d01b224a90911881c0f5435ca4995c96d6d26575"
    sha256 cellar: :any,                 arm64_sequoia: "e77030c245d7c639a0d4b5c1d0f23ff272c78bb8e46b1b3a53c62d5f7d20e723"
    sha256 cellar: :any,                 arm64_sonoma:  "7069fcc69d37a632f544475111d491c3daea096a1e4701374c300a5862875bfa"
    sha256 cellar: :any,                 sonoma:        "07e9e8a535ca16a5f3211825c438b32cf0dd4fcaf96eb7c0151b4ab10e13f5f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebc06804a889d1d207d1ffb40358e97e1f36bb9809f1022f9c47ca62b681fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c758fcc34e2bbc56a5554e2f0f32ee7bbd1cf8be117f2fe8829f270238b74bd6"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
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
