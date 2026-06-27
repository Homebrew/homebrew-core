class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.11.tar.xz"
  sha256 "2a6efd40b6d9dbcb70fba3be53112366882ba97b57151df3698dfa478c8d8dd3"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abb91d81b72750126191fb3a554cbce3acc3d818a40fa486ac63a24ad006fc5c"
    sha256 cellar: :any,                 arm64_sequoia: "3867b68556bba12e953a1a6e09beb68ad9431c8a66222ce8dc1f152b62537c55"
    sha256 cellar: :any,                 arm64_sonoma:  "523315829cb4aff25a06d1863a6e16602c7fdeaeeda94056f26e1b60bc222d6c"
    sha256 cellar: :any,                 sonoma:        "9d6d4f6ede6d71b76fb8d57195129927429c0d77b6ce1eeb433d974efb614c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569b4e56d3341421f740f3677036961235fbe9d9cfc044d344cc23aa161480b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5d2b1e7fef85b28cabbbe070360b116d75ed5219a916a14374a9f8a4c1e38a"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  def install
    # icu4c 75+ needs C++17
    ENV.append "CXXFLAGS", "-std=gnu++17"

    system "./configure", "--disable-silent-rules",
                          "--disable-static",
                          "--disable-tests",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
