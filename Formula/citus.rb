class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.1.1.tar.gz"
  sha256 "2494184d6ac7a6b66bb2380daf4abc616c931d33737179dbaca64c9760542187"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0e98ca621a36ea07b194558997512b701af14533b247962395bdcf3f09c7e675"
    sha256 cellar: :any, big_sur:       "8bf36aead06ce6aebfffd6e8ec40269bf3b5eb5b40168abe7cf1f159f1a26ed2"
    sha256 cellar: :any, catalina:      "5e0ab05900f8144950195e16362a8e7892038ca3c2082403b64bca5c1bf9e135"
    sha256 cellar: :any, mojave:        "243bca46ceacb61d3738f1b17815cd64adc4035c23d060b130bb82876001eed6"
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
