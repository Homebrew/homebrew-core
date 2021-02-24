class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.0.1.tar.gz"
  sha256 "0405ae3710c3bf498ce4ef1b3020a4d42424504e1e17595858d5fd51ebde422d"
  license "AGPL-3.0"
  head "https://github.com/citusdata/citus.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d1a40bc5b6cad0ddc3c665b4d59a095f27ad653b0e5cf236bf48fde1e4ddec26"
    sha256 cellar: :any, big_sur:       "53d87358b30badc7bcc3f897cd64967c2a39f48a821a151c221da4e9559ce5ef"
    sha256 cellar: :any, catalina:      "86fcf354388d050a9186a9c68007125112faea90ec573cfaff2cdc0388c9bdbc"
    sha256 cellar: :any, mojave:        "ab5ab6d6fa67b9b738a93be967ec935992ea66e1f2eea4b540f43e56eb31e76b"
  end

  depends_on "lz4"
  depends_on "postgresql"
  depends_on "readline"
  depends_on "zstd"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
