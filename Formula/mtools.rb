class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftpmirror.gnu.org/mtools/mtools-4.0.18.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mtools/mtools-4.0.18.tar.gz"
  sha256 "30d408d039b4cedcd04fbf824c89b0ff85dcbb6f71f13d2d8d65abb3f58cacc3"

  bottle do
    cellar :any_skip_relocation
    sha256 "de7062ca18e6d30d03576b3f62d0ab03b2198ae743f8edb3c38ace82934b61ed" => :sierra
    sha256 "5d0f845ba2f37a4f3a6c30522889d5ad574e1cede8884d1d38757fb9993a8c58" => :el_capitan
    sha256 "fab1e3ca4c7446687ab6001bfee835f15c452bc2fe6278581ba6491f05b72ff5" => :yosemite
    sha256 "2415b06b3cc473180cf59e0bd13a4b373ea38996afea75fc24a3f6d71f8bea38" => :mavericks
  end

  conflicts_with "multimarkdown", :because => "both install `mmd` binaries"

  depends_on :x11 => :optional

  def install
    # Prevents errors such as "mainloop.c:89:15: error: expected ')'"
    # Upstream issue https://lists.gnu.org/archive/html/info-mtools/2014-02/msg00000.html
    if ENV.cc == "clang"
      inreplace "sysincludes.h",
        "#  define UNUSED(x) x __attribute__ ((unused));x",
        "#  define UNUSED(x) x"
    end

    args = %W[
      LIBS=-liconv
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mtools --version")
  end
end
