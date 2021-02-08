class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "bf5bff9fcedd614bb641d3ac2bfe1c0c5d226cffd4bdccdc4ea011cfe307000b"
    sha256 cellar: :any, mojave:      "d2758c2643cebe884e575a44e8f36defb68519326898dccc5dd13e2046235ea5"
    sha256 cellar: :any, high_sierra: "c7eb62b441f09798e91098a082b8835184c98292822cf5606a3bc83d0627559e"
  end

  depends_on "postgresql"
  depends_on "protobuf-c"

  def install
    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
