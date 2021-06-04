class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.0.3.tar.gz"
  sha256 "42fb6908eba4713704d4cd1f53b7dae3f2f51c0865d63f9dc7be6693c8d5ba40"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "57bc55b52cf75aa6be2a8005c88cca5a7b100dfe9d7bad6b3e07fdfd4b2d9605"
    sha256 cellar: :any, big_sur:       "8e89c8a73c422d729d757fcf222997907429c3406dd6882f7ddf5b7233d3bbe8"
    sha256 cellar: :any, catalina:      "0b1b2ed735e95ffdb19ae6e875c1b1a232fa84d35a7ef23f6093354f3c155d30"
    sha256 cellar: :any, mojave:        "5e61831c224d8be0f08fcbeb3a3841feeb2013ec3d0f80fbcf6dc94e1fffabe1"
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
