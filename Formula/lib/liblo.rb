class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.36/liblo-0.36.tar.gz"
  sha256 "c08d14832e8dcf8f06840405824a4f9611a0cb3daed0198946326c740941c8b6"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e5c9bbe029eb036a57ceb3ac9d21c86207b7664d8090fac3f965a4e727f2c40"
    sha256 cellar: :any, arm64_sequoia: "0ecd70af8934a06beeefe747b9e3ef582c94ea9614755e50ae3e56b6378ef0b7"
    sha256 cellar: :any, arm64_sonoma:  "878d985c3f7a2e53c3adcc65e308b7e2370f737c2c4702926c826daf8b3ac54e"
    sha256 cellar: :any, sonoma:        "965e2bc2f34568601a389b8d362a9372daae9f4a8af538195ea8c27041b7d4ea"
    sha256 cellar: :any, arm64_linux:   "ece61966fa563a4892581668e9fbed446d46241c6ea6047f85cd210cf3d418f1"
    sha256 cellar: :any, x86_64_linux:  "e36cf1ed039648e309e60598cb1812342295fba148efb5ee1625ddb895873662"
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
