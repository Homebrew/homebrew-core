class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v10.2.0.tar.gz"
  sha256 "ec172e09d2569c09c09ccaf091a50646937eee830b0af0315750c1aab2ef0cc5"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aa4d9d13a6a6c86d7b6ff411ecde3a366a8ed492f22dd615ec065e31fc58c47f"
    sha256 cellar: :any, big_sur:       "9a7f4ae0ade23ee3cd055488e3611c9b34a9e91e5745f0cb3ddcbacf39851c38"
    sha256 cellar: :any, catalina:      "8b15dc9cdf4330d2d23790deb7091db586ec1d1f802588e32e6f6c91a452f15a"
    sha256 cellar: :any, mojave:        "4c4749e1c83a4cc26c172d72e6aac888ef8fa0df31e1aadb96530ef59a0d4504"
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
