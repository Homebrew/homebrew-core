class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e8891a0d34043f651e21e61d5f896bad2f36eed0a3a4f8bac49c453924bd8dee"
    sha256 cellar: :any,                 arm64_monterey: "f4b421e5d9ee59a760ff188d0b695a8ec266b65e7503085d59c4f89f73326fe2"
    sha256 cellar: :any,                 arm64_big_sur:  "221261761221ba1a3aa0d12bbd6c7c1e9710a942d4cf0bda373cda3128aa71e6"
    sha256 cellar: :any,                 ventura:        "b82c1097d8986d273ecf37720a6ceec797403ae1b18f6786d9e5697ae225575e"
    sha256 cellar: :any,                 monterey:       "f9632c66ce3e68c0f377f4579de7a702de40de6c0a5870effae2af492fe635a7"
    sha256 cellar: :any,                 big_sur:        "70e37b3984b6b0bfde28ed9db0049226b781ddec35c6bb9f7e4f677780bd6bc6"
    sha256 cellar: :any,                 catalina:       "cf773b6ddb214688cad1505cc01f4e3f6a4ddea8139d67d6c3d5fe2a7f8d8cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1b7a165d961b4025065b2b2e9a0088ea19f02973d705d3427633a7544f5b056"
  end

  # https://www.citusdata.com/blog/2021/03/06/citus-10-columnar-compression-for-postgres/
  deprecate! date: "2021-03-06", because: "cstore_fdw has been integrated into Citus"

  depends_on "postgresql@13"
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

    # Help compiler find postgresql@13 headers because they are keg-only
    # Try to remove when cstore_fdw supports postgresql 14.
    inreplace "Makefile", "PG_CPPFLAGS = --std=c99",
      "PG_CPPFLAGS = -I#{Formula["postgresql@13"].opt_include}/postgresql/server --std=c99"

    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql@13"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    pgsql_prefix = Formula["postgresql@13"].prefix
    pgsql_stage_path = File.join("stage", pgsql_prefix)
    (lib/"postgresql@13").install (buildpath/pgsql_stage_path/"lib/postgresql").children
    share.install (buildpath/pgsql_stage_path/"share").children
  end

  test do
    expected = "foreign-data wrapper for flat cstore access"
    assert_match expected, (share/"postgresql@13/extension/cstore_fdw.control").read
  end
end
