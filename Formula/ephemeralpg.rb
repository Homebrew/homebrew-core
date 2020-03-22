class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-2.9.tar.gz"
  sha256 "09314fe7d7ba2c26fb02864b9ddc92a538bc53674200363e77bb53a2fc1c17be"

  bottle do
    cellar :any_skip_relocation
    sha256 "c02e04cf822d9a12c30126152a1003c2fe545e6c0dbda9c893ef5d165a342722" => :catalina
    sha256 "b880f6d03f12cc1c0f0c9b4a4726bbc0870cfa2c14e4eacc8a62f8a7ddfa0082" => :mojave
    sha256 "b3c09234c2cfd5739e55758c0ff0516b4776213fbe0b157b25a7f60010977bb2" => :high_sierra
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    return if ENV["CI"]

    system "#{bin}/pg_tmp", "selftest"
  end
end
