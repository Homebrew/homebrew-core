class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-2.2.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-2.2.tar.gz"
  sha256 "dfd3df1cd222024439219fe82f2d3e64d0d2fad5e302a4e0c2ff0fc12a5b88ec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "af7e9dbfb79e73d85fae802c67081631d4cd91eb0589acd86b862d118de1674e" => :sierra
    sha256 "f8a48478b1fb03439265e149292e8c3db60b9c4b71a4cfa8e940422efef510c2" => :el_capitan
    sha256 "10d81ab2b2734f216f8afb639eb0f6e111fbad9d37281d219687835260671853" => :yosemite
  end

  depends_on :postgresql

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
