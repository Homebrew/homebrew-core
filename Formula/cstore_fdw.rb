class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "40f8f90ff00698421df744f2f50b2f7ebbd5fd85c1f8a34b181aa82f18c6af07"
    sha256 cellar: :any, big_sur:       "f31e1f58858d8c3379caa077e8944b088154ef4e2c24b6ead8fcfe630ec2e7a9"
    sha256 cellar: :any, catalina:      "59ef913883a6d6cf128621e06c2a0f83b753f6fa57c129634ed90650505d04e4"
    sha256 cellar: :any, mojave:        "02ff5c1993f5c35f7ac2ec660293c243670a7e467e4e0d7f012e3f7c62e62dae"
  end

  depends_on "postgresql"
  depends_on "protobuf-c"

  # PG13 support from https://github.com/citusdata/cstore_fdw/pull/243/
  patch do
    url "https://github.com/citusdata/cstore_fdw/commit/b43b14829143203c3effc10537fa5636bad11c16.patch?full_index=1"
    sha256 "8576e3570d537c1c2d3083c997a8425542b781720e01491307087a0be3bbb46c"
  end
  patch do
    url "https://github.com/citusdata/cstore_fdw/commit/71949ec5f1bd992b2627a6f9f6cfe8be9196e98f.patch?full_index=1"
    sha256 "fe812d2b7a52e7d112480a97614c03f6161d30d399693fae8c80ef3f2a61ad04"
  end

  def install
    # Makefile has issues with parallel builds: https://github.com/citusdata/cstore_fdw/issues/230
    ENV.deparallelize

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
