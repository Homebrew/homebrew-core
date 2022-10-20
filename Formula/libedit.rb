class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20221009-3.1.tar.gz"
  version "20221009-3.1"
  sha256 "b7b135a5112ce4344c9ac3dff57cc057b2b0e1b912619a36cf1d13fce8e88626"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "96ed938c9086a19b64c178e5e2bdee40a3e9a517c9a9b0728e5856e7504dd5e9"
    sha256 cellar: :any,                 arm64_big_sur:  "8efaf36912b6167b6c51a358b390b458a712a61688b030c0fb29b044356835ea"
    sha256 cellar: :any,                 monterey:       "4ddaa46a838d39980fadecb590e52677a3ee340d5ff7ed6e5f84882e84192b08"
    sha256 cellar: :any,                 big_sur:        "2f547dc8ea087c7b92d8be9d92af27b1009427a2ce604ad93cd99adb9184a0cd"
    sha256 cellar: :any,                 catalina:       "abd38ffe10b66ea11abe777bcfbb2f411be9db3949aa91472837194b71e9e3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e298a55684eb4cb7c8e204f78464b265ab0c842e60e21896e2acf42d3de0b8ca"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    if OS.linux?
      # Conflicts with readline.
      mv man3/"history.3", man3/"history_libedit.3"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
