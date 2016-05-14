class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.5/gperftools-2.5.tar.gz"
  sha256 "6fa2748f1acdf44d750253e160cf6e2e72571329b42e563b455bde09e9e85173"
  head "https://github.com/gperftools/gperftools.git"

  bottle do
    cellar :any
    revision 1
    sha256 "35a478cc1f30e79b07099318b24d82fbdcbb53bc52cdd09688c55ba3f8e12d72" => :el_capitan
    sha256 "86f429aa714330a0b550397e306f691340e4beaa5dd3def7d62a3cb42b5200de" => :yosemite
    sha256 "8b50e2171af61bf38094d6173d5c39d34c42559440c94ca27fae750e8012cb17" => :mavericks
  end

  # Needed for stable due to the patch; otherwise, just head
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  # Prevents build failure on Xcode >= 7.3:
  # Undefined symbols for architecture x86_64:
  #   "operator delete(void*, unsigned long)", referenced from:
  #     ProcMapsIterator::~ProcMapsIterator() in libsysinfo.a(sysinfo.o)
  # Reported 17 April 2016: gperftools/gperftools#794
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/edb49c752c0c02eb9e47bd2ab9788d504fd5b495/gperftools/revert-sized-delete-aliases.patch"
    sha256 "49eb4f2ac52ad38723d3bf371e7d682644ef09ee7c1e2e2098e69b6c085153b6"
  end

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE"

    # Needed for stable due to the patch; otherwise, just head
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-ltcmalloc", "-o", "test"
    system "./test"
  end
end
