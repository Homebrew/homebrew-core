class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78cba62624a4f42f39f50b059cc400802e9bf9f75083a6582ac3a0c9e43e538f"
    sha256 cellar: :any,                 arm64_big_sur:  "7150e6ca48f68acdc46dcb2db908fa6ffbfa6e9924bd1a6aef9873beb308522e"
    sha256 cellar: :any,                 monterey:       "8475a654cb0aff0f9c355b4334b862b78ff7cf6222c04847e1346dc70979f636"
    sha256 cellar: :any,                 big_sur:        "72fadeff938269dc37235e25917196ecb67a2d645c106adc1310d09841e599cb"
    sha256 cellar: :any,                 catalina:       "dbb68dd9be281e6731f6dc33305a7be86b77c47910cc0534126bba63cd5068ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dce4b860d7534d3701d8f78c0b4ba73ad48cbefa3b996b03e572c6469133ae5"
  end

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

    pgsql_prefix = Formula["postgresql@13"].prefix.realpath
    pgsql_stage_path = File.join("stage", pgsql_prefix)
    (lib/"postgresql@13").install (buildpath/pgsql_stage_path/"lib/postgresql").children

    pgsql_opt_prefix = Formula["postgresql@13"].prefix
    pgsql_opt_stage_path = File.join("stage", pgsql_opt_prefix)
    share.install (buildpath/pgsql_opt_stage_path/"share").children
  end

  test do
    expected = "foreign-data wrapper for flat cstore access"
    assert_match expected, (share/"postgresql@13/extension/cstore_fdw.control").read
  end
end
