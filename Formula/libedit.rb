class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20210910-3.1.tar.gz"
  version "20210910-3.1"
  sha256 "6792a6a992050762edcca28ff3318cdb7de37dccf7bc30db59fcd7017eed13c5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d94db2216d13244df5b1b3a5d8a158c5a8403090b08b9acaf146c10c3226d4e5"
    sha256 cellar: :any,                 arm64_big_sur:  "87f49ccb584888cb95885c09a586ec0d97f7d3813cdc38f66e07690143226583"
    sha256 cellar: :any,                 monterey:       "95938022416b3a19c67763eef069c3b98922f58d87a5c2c0d6a654a9a9a08323"
    sha256 cellar: :any,                 big_sur:        "f1c631b30d1daf17da2bdd3d1f59330d99439ff15dd573e52364bc014a664803"
    sha256 cellar: :any,                 catalina:       "38e6ae9c4fd560bc93003106a786fac1e26749426b837e8f92fb38b547b0edb7"
    sha256 cellar: :any,                 mojave:         "44e7ce6ef6d1f558f565d03e4287d6da98a36e120b736a083d5c751669fdb7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0bdbd74d04e366389621c1951d0a1de06a359c19da5c2c5b847605bca617753"
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
