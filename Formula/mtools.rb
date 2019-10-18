class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.23.tar.gz"
  sha256 "110881884bb447b6243471dab4def937a344267a05ccc60a13503065ac992c39"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ac51535ed5eafba74ec14886735ea2cd79768d72c688d97fc1a49d8f5b73fce" => :catalina
    sha256 "541d3f5c8c8059dade3f91871f71c97c9ceff2987e97c95f4fefb57a8b55fc44" => :mojave
    sha256 "402e30be30bc720b3bc8249da0ce56e7378f6e6f62ea68ddae27d558e438bca7" => :high_sierra
    sha256 "c3fea7a5246d365ef2d4466b0722102afaf39a362b5127ffbe084de03b7afcf0" => :sierra
  end

  conflicts_with "multimarkdown", :because => "both install `mmd` binaries"

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
      --without-x
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mtools --version")
  end
end
