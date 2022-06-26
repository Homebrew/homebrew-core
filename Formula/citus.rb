class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.0.2.tar.gz"
  sha256 "86ab78b6efc4739c7de3af935317b7ef6a7646250d80ccc0ab31ad28fc49070a"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "afe268ba6b10df8731949bd09b0ea24c0c8e1c9d8fba377a3b0f539b73ad9489"
    sha256 cellar: :any,                 arm64_big_sur:  "fcd5150a610ca4a3076873a87901233a0d88dd0dde9ecc9ac8cff247f5ae4d94"
    sha256 cellar: :any,                 monterey:       "2027a7e5e6df547333f93206720923ddfac774afc07a9cb72e21b1d431a19942"
    sha256 cellar: :any,                 big_sur:        "6cbeacf7159db78b02132689f39b74158f5396991065b57964e79bd685e22fe5"
    sha256 cellar: :any,                 catalina:       "1e20dc813c5d4481e72a96d986e62ef23f09efd1004600df5d26528c6e01c03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2696db8b59598fdd67e0c4b70012005f686ba53ae607222dac7a70e69d9ea468"
  end

  depends_on "lz4"
  depends_on "postgresql"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    system "./configure"

    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/path/"lib").children
    include.install (buildpath/path/"include").children
    (share/"postgresql/extension").install (buildpath/path/"share/postgresql/extension").children
  end
end
