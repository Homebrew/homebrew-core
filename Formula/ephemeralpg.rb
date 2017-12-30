class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-2.2.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-2.2.tar.gz"
  sha256 "dfd3df1cd222024439219fe82f2d3e64d0d2fad5e302a4e0c2ff0fc12a5b88ec"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "16030c95a119e8cfbe281d0dc1184c2d973321bcbed042edc097b064a90805ef" => :high_sierra
    sha256 "60c8611009dc31b7e96892efdbff55292a54b2f8d0ca3ea907364beab4b2be6c" => :sierra
    sha256 "7cf339bceca0f80ace1936fb4229d793b0b566f06854fa62d860c12de1470f69" => :el_capitan
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
