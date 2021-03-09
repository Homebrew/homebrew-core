class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.0.2.tar.gz"
  sha256 "a87381db7b26078955d733270a9adfdcdf1ec5ce5a698d475d86b5e65ae6a157"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f384af08a00045390e46cf4390015fca3e3f93b987af1afa876ca9eabc5015d6"
    sha256 cellar: :any, big_sur:       "667481e1bc2f24347a4f59a275f574fd820e88150b88cc9f023d4bb35f1117bd"
    sha256 cellar: :any, catalina:      "caee2277ccdf2fc3fec2c3e2c20b350f7a596cab87e33f5c4cebb409908e1c85"
    sha256 cellar: :any, mojave:        "5b7e7f03d391ba0958e9167d7011c352f74c3b07860f774446d6a60d4ae2852d"
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
