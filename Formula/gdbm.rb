class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.18.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.18.tar.gz"
  sha256 "b8822cb4769e2d759c828c06f196614936c88c141c3132b18252fe25c2b635ce"

  bottle do
    cellar :any
    sha256 "db81127b326d88c2efefabb5ca342dc9b370f1114c11fe9498a741f9209c7a59" => :mojave
    sha256 "e91bf89f6fcca5e2a243ad767873d4f4b401167e7463d62464e9649e0cc2b0a4" => :high_sierra
    sha256 "98fff905aafc37d57debce4dd54cc69bbeeca6e07f90e0ce68094d8d78116af0" => :sierra
    sha256 "346aafe3a7b44b5d8b89df3cecf436f97d657705d19989948c873b010ddb534c" => :el_capitan
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
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
