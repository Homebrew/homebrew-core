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
    sha256 cellar: :any,                 arm64_tahoe:   "5d82d39e2a9d1767965befc3873337ddddfe1e5623a433c79276b348479242a0"
    sha256 cellar: :any,                 arm64_sequoia: "9583474ebb254aeeab8a81c8862ecebc268acb3de3f4396bb4a83e3f856bd274"
    sha256 cellar: :any,                 arm64_sonoma:  "fe3cee6fa9830c162fd068bf8a88ce7ca97a96f8c8a930f3d85a18693041ec96"
    sha256 cellar: :any,                 sonoma:        "3275f34494561a0e9d0e07e453f2704fb980beee725a31d31157767e91798941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dffcc35d0d4b1424eb1faf29b3456b96d65b7283b88e208960b68d846c91574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebb5d2f2b63c1088bd4056d1c85494802aedee661624eded24d75a1a9ccdb1b"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "librevenge"
  depends_on "little-cms2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
