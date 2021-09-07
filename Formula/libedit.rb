class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20210714-3.1.tar.gz"
  version "20210714-3.1"
  sha256 "3023b498ad593fd7745ae3b20abad546de506b67b8fbb5579637ca69ab82dbc9"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "13d4e88e23a6c82ca458d3ca287af597b27ac211d258ef825bc0a4ab3111a80b"
    sha256 cellar: :any,                 big_sur:       "75d0b470e0478010fbaa2708db5eefba895d71d32efe79bc3eee389e26375bb7"
    sha256 cellar: :any,                 catalina:      "b28c79aa687f372834237a8a13ff274ff91bbb378aaa7bdd055411a0817427a7"
    sha256 cellar: :any,                 mojave:        "b011a5735eee4db2740abc9cc25703e9dcf89da5f79e5d210a3a1e8609f9205e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08fede13bbc6910dbb2cc33aac6d4846b933713118e19503e09490f2404d3994"
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
