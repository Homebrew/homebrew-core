class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.1.1.tar.gz"
  sha256 "2494184d6ac7a6b66bb2380daf4abc616c931d33737179dbaca64c9760542187"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "55ca70957f451ac2e369b83d09f2e381a3d474a7963d0f4fa062f2b184d1563a"
    sha256 cellar: :any, big_sur:       "ddb0ea0a2af6fa10982bec99201ad024338fa49d7151924ae4b303a18c01de1b"
    sha256 cellar: :any, catalina:      "c2db86947e92a6bea0025aa43ffc22cba47fc5920beb4461efd38604e8d4e00f"
    sha256 cellar: :any, mojave:        "4fe4630cbd313aea0a3f1c4c5dd7ce1d6c0a01fc4afb37a5453a2e9a35c174a0"
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
