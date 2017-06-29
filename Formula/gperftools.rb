class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  revision 1
  head "https://github.com/gperftools/gperftools.git"

  stable do
    url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.5/gperftools-2.5.tar.gz"
    sha256 "6fa2748f1acdf44d750253e160cf6e2e72571329b42e563b455bde09e9e85173"

    # Fix finding default zone on macOS Sierra (https://github.com/gperftools/gperftools/issues/827)
    patch do
      url "https://github.com/gperftools/gperftools/commit/acac6af26b0ef052b39f61a59507b23e9703bdfa.patch?full_index=1"
      sha256 "164b99183c9194706670bec032bb96d220ce27fc5257b322d994096516133376"
    end
  end

  bottle do
    cellar :any
    sha256 "f007d19e148f697e681ba71f9c3721ec1f9640b7a48bd0a55c129085ba1a3a89" => :sierra
    sha256 "f29fe0e250ee9cc6cba00dc839bf0097db992ba4ec11aff4ab9dbd69e7dd10e8" => :el_capitan
    sha256 "e6af4a9899529cf2aa1ab0c7c6a667cf1a1df9a207a51c0dbb64128d1e1f1d05" => :yosemite
  end

  # Needed for stable due to the patch; otherwise, just head
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Prevents build failure on Xcode >= 7.3:
  # Undefined symbols for architecture x86_64:
  #   "operator delete(void*, unsigned long)", referenced from:
  #     ProcMapsIterator::~ProcMapsIterator() in libsysinfo.a(sysinfo.o)
  # Reported 17 April 2016: gperftools/gperftools#794
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/edb49c752c0c02eb9e47bd2ab9788d504fd5b495/gperftools/revert-sized-delete-aliases.patch"
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
