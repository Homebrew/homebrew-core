class Libmdbx < Formula
  desc "One of the fastest embeddable key-value ACID database without WAL"
  homepage "https://erthink.github.io/libmdbx/"
  url "https://github.com/erthink/libmdbx/releases/download/v0.9.2/libmdbx-amalgamated-0.9.2.tar.gz"
  sha256 "c35cc53d66d74ebfc86e39441ba26276541ac7892bf91dba1e70c83665a02767"
  license "OLDAP-2.8"

  def install
    system "make", "all"

    bin.install("mdbx_stat", "mdbx_copy", "mdbx_dump", "mdbx_load", "mdbx_chk")

    lib.install "libmdbx.dylib"
    lib.install "libmdbx.a"
    include.install "mdbx.h", "mdbx.h++"

    man.mkpath
    man1.install("man1/mdbx_stat.1", "man1/mdbx_copy.1", "man1/mdbx_dump.1",
      "man1/mdbx_load.1", "man1/mdbx_chk.1")
  end

  test do
    srcfile = testpath/"dbentries.txt"
    dbdir = testpath/"test.mdbx"

    srcfile.write("foo\nbar\nbaz\nbatim\n")
    system "#{bin}/mdbx_load", "-f", srcfile, "-T", dbdir

    assert_predicate dbdir, :directory?
    assert_match "No error is detected", shell_output("#{bin}/mdbx_chk #{dbdir}")
  end
end
