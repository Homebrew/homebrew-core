class LibvoAacenc < Formula
  desc "VisualOn AAC encoder library"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opencore-amr/vo-aacenc/vo-aacenc-0.1.3.tar.gz"
  sha256 "e51a7477a359f18df7c4f82d195dab4e14e7414cbd48cf79cc195fc446850f36"

  bottle do
    cellar :any
    sha256 "099ac7d191241c476ab4ba7375dd05e2d965adc6a7638cc616a99a243cbd077b" => :mojave
    sha256 "761ecbbaaa2a944d077040692fc62fe2e929ec788ca7e23b3fb25e6ee1b88d3a" => :high_sierra
    sha256 "9430e86c9f25aa9fcccf0a19cc6125c9397c23b311b993b1adf83cbe330cd9b4" => :sierra
    sha256 "e9a59439f8eec4cdc4d273afb49cbd8f8357862d4d8c7c5d9d9d38588ec6d810" => :el_capitan
    sha256 "cf63ddcb79e40b79264507393ed4fa1b223feecf4638f0e58fef464db722b554" => :yosemite
    sha256 "645f4294e8512add5c5f263cd8273c93e22eab565307ada5f8804ef7b9d41d8d" => :mavericks
    sha256 "1a2fc17d25d424a4385d2c792b4e09ff0409b5c264cc03aec2182e40dc21295a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vo-aacenc/cmnMemory.h>

      int main()
      {
        VO_MEM_INFO info; info.Size = 1;
        VO_S32 uid = 0;
        VO_PTR pMem = cmnMemAlloc(uid, &info);
        cmnMemFree(uid, pMem);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lvo-aacenc", "-o", "test"
    system "./test"
  end
end
