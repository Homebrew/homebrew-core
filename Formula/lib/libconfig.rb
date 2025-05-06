class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/refs/tags/v1.8.tar.gz"
  sha256 "22e13253e652ec583ba0dd5b474bd9c7bd85dc724f2deb0d76a6299c421358ef"
  license "LGPL-2.1-or-later"
  head "https://github.com/hyperrealm/libconfig.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1582c0c9117c9a775cdc0898fe45f8c543bcb5236035228a1150dfc7a9ed7ce"
    sha256 cellar: :any,                 arm64_sonoma:  "7b5064bff1eb6a30a0172c2050dc6a29f0a8e15b038bfea0336def3363b08672"
    sha256 cellar: :any,                 arm64_ventura: "4ef4fe93b31d05bd5849c306010fe6b00c0e9836fff6d9004add313db4b56cc9"
    sha256 cellar: :any,                 sonoma:        "021fe870c6883aa87b7295dbc0f8ab0a9043809fbeb18079b592d07989d09025"
    sha256 cellar: :any,                 ventura:       "80ad14edf165d87fe442a3583ab2d3ca5aef504ff31ea634a4511da198d724b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5931f3faddd9baa428b034285bf08357765a69e54e8a4e49160f866d88bab368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e597a3334e1b4e1043d909232489cc1ef255a49522e9bdc1849be4afb968ab3f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    C
    system ENV.cc, testpath/"test.c", "-I#{include}",
           "-L#{lib}", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
