class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.0.4.tar.gz"
  sha256 "2b3e705e4a798dafe1052ffed00cfedfd8033a23490bfb88a627358381e6fa33"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0952be6e5524bb6e15ca4bb0e9ed58bdfad72786dbcc8bdea2ad502222f0aacb"
    sha256 cellar: :any,                 arm64_big_sur:  "f0b1521e3f27b075eb141fbd9e61ffb1eafbb7a3259945070f79bc82805346c6"
    sha256 cellar: :any,                 monterey:       "02896a9000428fe5e6b3087e52e6642e9a3ccefb0c52495b9bbc843e7c78fa77"
    sha256 cellar: :any,                 big_sur:        "1da680511086cd1bb95ca946dca4af72a5e52b8b62179ccaf937d437fcb49a2e"
    sha256 cellar: :any,                 catalina:       "d1ea6387ec8dccae8ff61b2d1ffca23c6a26aae713f6702f1b97c4b6b4906d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a1719b291247bdbb80843c87582bf7b667c73c2e0165d19c67e7514ae9136a"
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
