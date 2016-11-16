class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-1.9.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-1.9.tar.gz"
  sha256 "3caf06f2be5d9f206f3c1174cc0c44cc359357fc7d41da026f858e01ef192792"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "84b3c285e1def06a9162b31072f6ca4dbaeb7d4e4396e1ce95cc86c17b800211" => :sierra
    sha256 "1bcf61fd5f635b49f5bc23aad9d1d5e4ee6a9e069ac6096b83c528435ef11c16" => :el_capitan
    sha256 "9059ed43dc9c205410ac132ef7385542a3c066701f01a35e173fea6313aacf35" => :yosemite
  end

  depends_on :postgresql

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
