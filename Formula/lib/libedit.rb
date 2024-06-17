class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20240517-3.1.tar.gz"
  version "20240517-3.1"
  sha256 "3a489097bb4115495f3bd85ae782852b7097c556d9500088d74b6fa38dbd12ff"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4190db11789aeda7fb60afb3316a8a46145899e6976b3b6577c25a37e39a91a"
    sha256 cellar: :any,                 arm64_ventura:  "4c7b70562b9e2cc617554283d5b83ea52bdf2a06288bd4c927a781716482106c"
    sha256 cellar: :any,                 arm64_monterey: "f665cbc9c6a187b9eb592d8c74cb9dcb9e1de82d87af65e725cf66f7252b26d7"
    sha256 cellar: :any,                 sonoma:         "3897ed8b457a813b437acd32a74c989b955d0294b8473c03c9663ec3a7e62541"
    sha256 cellar: :any,                 ventura:        "38f2acd95585e42c83f407f54af077ba34cb8b5800930fe3536c1f707171bba9"
    sha256 cellar: :any,                 monterey:       "b6405804a036f4088513e757ddb940f53b86486d4fd968c786dc4eb6259f9baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5eda364492fa30e07098bea7259d970c221dffce51f570594a5b94c50a435ee"
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
