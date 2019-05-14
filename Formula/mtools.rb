class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.23.tar.gz"
  sha256 "110881884bb447b6243471dab4def937a344267a05ccc60a13503065ac992c39"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "082a30c7f075085d136c7d2c001fc02e5b1ff47404ebc67ea53819031a878835" => :mojave
    sha256 "f630af7b561b34f06e1f233211d66115c7b65365b3676058e6d91454f0e9941c" => :high_sierra
    sha256 "cd5cbd343ef7f50ddb53be99ea5f5a7bd1ccddea252924bfd57fef84a69095a9" => :sierra
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
