class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.34/liblo-0.34.tar.gz"
  sha256 "69aa0cd365dba5ea7799b850a7da659ad303e6074bbd67f4ab84e4d6f5f6c3a4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f08a0362c895fd58456663358085ba1641a39f0fc74d62136c07efeb4d25e299"
    sha256 cellar: :any,                 arm64_sequoia: "a9e38a71645c64dc13e45f4fd3d9b7e12fed84c15cfed55d17e3e23d10138691"
    sha256 cellar: :any,                 arm64_sonoma:  "49cd38572b94d428f60ec1f1587537ba71cdcccf9f2a11f496f0c9f611e7fafd"
    sha256 cellar: :any,                 sonoma:        "e6e20a668824e9b917bc5b07dad6c338668c4e4ed561df20b630fceb24c0321e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10cedad46fbb3f57a057122e5d4fad858108996c40b1cec044d6d9fe9e096ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e119d8b42b66ba6da8115416827c9dfdbcaeea774b2b2d707c74fdce4e467da2"
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args
    else
      system "./configure", *std_configure_args
    end

    system "make", "install"
  end

  test do
    (testpath/"lo_version.c").write <<~C
      #include <stdio.h>
      #include "lo/lo.h"
      int main() {
        char version[6];
        lo_version(version, 6, 0, 0, 0, 0, 0, 0, 0);
        printf("%s", version);
        return 0;
      }
    C
    system ENV.cc, "lo_version.c", "-I#{include}", "-L#{lib}", "-llo", "-o", "lo_version"
    assert_equal version.to_str, shell_output("./lo_version")
  end
end
