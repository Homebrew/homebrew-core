class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.32/liblo-0.32.tar.gz"
  sha256 "5df05f2a0395fc5ac90f6b538b8c82bb21941406fd1a70a765c7336a47d70208"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8373256cd53294a3a06252d55c8cc93d6c6a6f8c3b235084cab456931e67e1b3"
    sha256 cellar: :any,                 arm64_sonoma:   "c379d421a02f1afa3c6105e527dc71b5271450f2964f31b6f6117fd826c8f783"
    sha256 cellar: :any,                 arm64_ventura:  "1395a951f82712482f5f90cd4a4803d88044154029cd3cd1d2fb2fbaf0f357c1"
    sha256 cellar: :any,                 arm64_monterey: "e79362d970b3c7a741336f9e02e3d738f43169bc5fddd6972dfae327d4dfe8ee"
    sha256 cellar: :any,                 sonoma:         "79de8fe2295a65736c7a7de5a2a24e6b62bc8745dd692a330c208e4b717b65e6"
    sha256 cellar: :any,                 ventura:        "98ec4c770688b3f59d46c99eda7c052eee63ff6c8ab4b874bc56db2942dad96f"
    sha256 cellar: :any,                 monterey:       "8f4e3f2fd6ce732d7d170f1db5193f9b53b233fcb08b876cc66114b252f465cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9a3ae0a7f62dc172def171ed8c833e44fa72b4ab6a798f9b3c897b5e402e8b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62fbd9950f4178a2ec7eeb280aac525b10d483953417f750aca24b420089b157"
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
