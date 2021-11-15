class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.2.tar.gz"
  sha256 "5dd2c8235bf406c3f5e0b1d5def6280a356744efb18f97467f26120555823c35"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e83494e8cd572da3a0bde221f24eb60a50fa73aff13cdcd6d149cad32b24a893"
    sha256 cellar: :any, arm64_big_sur:  "b908cb7df76f9ec5dfb3d6cd0d763b4b109c16a11bfdc696a0e52a65dff5a90c"
    sha256 cellar: :any, monterey:       "88eb7b2ee529c584127418d3e65357ad246f1d8a3d34141ffc7022fc12a7e1e7"
    sha256 cellar: :any, big_sur:        "04071b6d71d5592141bc01b6118979a64a9c28cb9fceef071c781b1be8989ae8"
    sha256 cellar: :any, catalina:       "1812524584d286b57329a58cac23a5d5a4a86af25cee83c1fbc6252da97a0fe8"
    sha256 cellar: :any, mojave:         "a5a2d8975aac4af7d069edc040a88ad99361845e29414c17c7afd7eb0cecf254"
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
