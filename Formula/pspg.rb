class Pspg < Formula
  desc "Postgres Pager"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/v0.2.tar.gz"
  sha256 "9688a570db525194aeef1a1d859dbfdc947682aa94301f0f58c37aca940cfa56"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
