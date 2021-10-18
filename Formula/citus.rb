class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.2.tar.gz"
  sha256 "5dd2c8235bf406c3f5e0b1d5def6280a356744efb18f97467f26120555823c35"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b47ec0d9796d34889c9fe811df06f2a65fe1f776519f972f0996130ae3481c02"
    sha256 cellar: :any, big_sur:       "feff6c86199f9a6bd3f8b428235e796440186cfd18d04e5b89126bab2c732e74"
    sha256 cellar: :any, catalina:      "393d09b9e933308f489fcf82c6955551ce3e4a78525cbfd81731517860545265"
    sha256 cellar: :any, mojave:        "8bb9a88d1198ac3bc241e13a02b01b802ad9644d1688aa4c288646556aba486a"
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
