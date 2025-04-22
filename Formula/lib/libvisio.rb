class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.8.tar.xz"
  sha256 "b4098ffbf4dcb9e71213fa0acddbd928f27bed30db2d80234813b15d53d0405b"
  license "MPL-2.0"
  revision 2

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1d82aaa71ed70e5c67c507843c5e0ad1e7ed0baa1ddb0d65c92f382d2f209b8"
    sha256 cellar: :any,                 arm64_sonoma:  "548d6e3a65308733f84b62d945aa751a23498898250d2d9d10fc58d6af475d85"
    sha256 cellar: :any,                 arm64_ventura: "4cc867e8cbb1c6db5fceb6c50ccd440c90b7bccc9a71b4d251c4815ba69cc6c5"
    sha256 cellar: :any,                 sonoma:        "59b2d3c7b44168b3778795e95f730e361ad392107ff4de14a2ef4356234a2bc8"
    sha256 cellar: :any,                 ventura:       "cd2c9346d09b98e85f7bcee3da6571d6391b7456fc5feb61ba212ce9b8a7c68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab24a12cdf48c1b40d932fffa7f37b0dff96177c343a77865c1a9dfc6620fc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9f80d9caf8b35a27876747278ec7dc4247de6ff8f06c96cec900a5a09167c0"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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
