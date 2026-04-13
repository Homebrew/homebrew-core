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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e2428718f47c0d05853f80bc0e4578a223468a269320f8e5ca52c87e99afb96a"
    sha256 cellar: :any,                 arm64_sequoia: "6a858bcf883c4308b08456b366f0b31c337f40d041c0cbddb2bd1994db708758"
    sha256 cellar: :any,                 arm64_sonoma:  "df8a1571909caa08bad2913505550031b0cb6acc053d41ce5c70579c76cad69d"
    sha256 cellar: :any,                 sonoma:        "60e655184d0b933bb7c985e87d4b179e371421992d9cd68f3db6ca84c2612306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3425841969e05fc71350437f2f13388bc9e67fb3c1fb487f10e78cf227c8439c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79639eeb9420eed8e22b2757b6270bc7e5720ed7d8d28aa54a408a9533557b46"
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
