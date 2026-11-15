class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.9.tar.xz"
  sha256 "f7bb6abdd7f226820f288a93dd8d07759833c0250d9e202af90f9b312c4665a3"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "81ed0e5d207a8d214b9bb4385545f7ff980fd14e42062a6c25aff387ba771908"
    sha256 cellar: :any, arm64_tahoe:       "aae1e1ff4225174b8985a56f585ba4830edd6c742ffe83430fa679b97dd4b9b2"
    sha256 cellar: :any, arm64_sequoia:     "8ad1285cdbcb5cc534f8c3c48eb19a8542e6b0eb74c8e3f661367e0fa1094e26"
    sha256 cellar: :any, arm64_linux:       "6ad8939bd6153da91ad2bd70cd2461eec1bec0441e6fe051c748a3c5d5d043e5"
    sha256 cellar: :any, x86_64_linux:      "f99fb7e3aa6398e7feb12caf051b4f4301fa6897d4dec4d1e50449f2a3a77139"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"
  depends_on "librevenge"
  depends_on "little-cms2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
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
                                "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
