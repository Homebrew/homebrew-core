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
    sha256 "c57037299f11da6b4560707c9380bfdbb8708f379bf8fccae6bf0069d4dedd8a" => :catalina
    sha256 "61a09eb4b62f4fd794ceb1af70f21198840598cd859a40c59c0be8799132ff86" => :mojave
    sha256 "6889ddcf36023c982fe421ea8660445b416989968cc9a64b0a5156dd9f01cdfe" => :high_sierra
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
