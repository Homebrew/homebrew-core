class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.1.2.tar.gz"
  sha256 "cade8cfb842bac1b7522ed92f668293a316d0d3a383cca27ed7e9ef16be641d6"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5366b3445216b125427ad8a3272510173467d39799ea6ee01db93fe9d52cd343"
    sha256 cellar: :any, big_sur:       "3851ceb8cb83415b6a2241c0844eadf8fa5a67e011d308d3ee3e6918188adfd9"
    sha256 cellar: :any, catalina:      "8d41bc633847d9b9f9c9ec772e5800aac2c32f36020ff3c2d5f44220fdce1006"
    sha256 cellar: :any, mojave:        "3adcddaac15d575f8333b1cb233bb847ecb5f9d5f82e7a11556b4687ae2196f6"
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
