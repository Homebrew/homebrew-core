class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.1.tar.gz"
  sha256 "4693d195778c09a8e4b0fd3ec6790efcc7b4887e922d8f417bca7c8fe214e2aa"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0ebc56c6b29ac11305a81437a0c8aa5e6b31f9ab58daad8b695e3560870f09a3" => :catalina
    sha256 "56d56bf1bac23530fcdeb3d9b0f2161cac9ae606fdb19d61a08617a825cf31a6" => :mojave
    sha256 "ff9f13d039de049edbc0b9c085e3d49b263fe1d1a2c0e1f4c8184f121e435c9d" => :high_sierra
  end

  depends_on "postgresql"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    return if ENV["CI"]

    system "#{bin}/pg_tmp", "selftest"
  end
end
