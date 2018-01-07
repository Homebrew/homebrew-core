class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.14.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.14.1.tar.gz"
  sha256 "cdceff00ffe014495bed3aed71c7910aa88bf29379f795abc0f46d4ee5f8bc5f"
  revision 1

  bottle do
    cellar :any
    sha256 "359843d415b02908012c5619ebe67628ad3c7bcb666dca8f2ffe2399cb9bfec9" => :high_sierra
    sha256 "12e80dc27af21a9faedb26aaaf5330ff104a35735f0e3c9d7be71f9f46f9168f" => :sierra
    sha256 "cd5b482f99bd6dcf459be4421b5a94bb139bc8355e3329de3bedfbf6bf0d33a1" => :el_capitan
  end

  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --without-readline
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    system "./configure", *args
    system "make", "install"

    # Avoid breaking zsh login shells unnecessarily
    ln_s "libgdbm.5.dylib", lib/"libgdbm.4.dylib"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
