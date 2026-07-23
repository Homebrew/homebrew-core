class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.6/librevenge-0.0.6.tar.xz"
  sha256 "19eacf5ce55d7fe6a990a45142589cdf7da0c7b68701797f133482cb44f189fa"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url "https://sourceforge.net/projects/libwpd/rss?path=/librevenge"
    regex(%r{url=.*?/librevenge[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3dbdc968c050662db2bb67f93c3f2f473d69679090c1b25f703284efd2c21987"
    sha256 cellar: :any, arm64_sequoia: "0eabe12945f58c1a8673416a79409b17b410b27e67636b99005209cb6fd6b35a"
    sha256 cellar: :any, arm64_sonoma:  "276bd295f8b3079655366a652f886bd0fb275f6a348f1f89a9b286347e517bc5"
    sha256 cellar: :any, sonoma:        "c089420efbf6a13e03387a35018f2237d4769b2daf45a97ad158678d1319885f"
    sha256 cellar: :any, arm64_linux:   "4bafef5bb5011171c9e1361c422d876df40e50355f7b783176623a262ebf6ea2"
    sha256 cellar: :any, x86_64_linux:  "340007b50b1a953ada4548c322ccd4896af6c7df749e697ac7e25e7c089f0771"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--without-docs",
                          "--disable-static",
                          "--disable-werror",
                          "--disable-tests",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
