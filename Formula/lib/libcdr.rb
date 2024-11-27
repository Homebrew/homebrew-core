class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 8

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbc2a54bb8f6d6a4e466865b14d7b70a6fbc858d388548cf9b953f201de3c990"
    sha256 cellar: :any,                 arm64_sonoma:  "cc66b1548f086a48f271bf053c229ee390cd2bd1156903d29ff0021f0df9b5a5"
    sha256 cellar: :any,                 arm64_ventura: "4490629bd88271316e181a59054bdbca640a68fc742ad2e072b7c00d529787ad"
    sha256 cellar: :any,                 sonoma:        "1229fd37c6e1c8e952b63e78bd58778a92f64da3fda9f7f6ac0f07c6b8b61150"
    sha256 cellar: :any,                 ventura:       "d36c29ef45a56def001e4401ef3a2efce00352621ff1dd2f23260d6d6dadff5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f1b27844634dbdba55e73959c47a4cf20189936b203790f5f98ac48e7174c7"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@76"
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
