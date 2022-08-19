class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.0.6.tar.gz"
  sha256 "f3f2deb3e7f31844f4cc3bb0a311b52a4179cabe08c72b409819fa6f6e72f5f4"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f84cb462d0609277af24edc1ff82437a768601d0d0655535a1170f967073eaff"
    sha256 cellar: :any,                 arm64_big_sur:  "560b5916b6966b5a9055a17804781d99845e67debc243515ab147587896c065a"
    sha256 cellar: :any,                 monterey:       "525ece05eb86dcd20a71bc0194aeeaab17cae638d58a707be58e1fef02f175a4"
    sha256 cellar: :any,                 big_sur:        "4e0d7887bac5768ef047b21ba46cc1fa829fd911ef3fb27d035ed86af08f1e22"
    sha256 cellar: :any,                 catalina:       "558f3e1704cddf815a593ace7115faf68d75c9adc1c8d607d0d150dc36412df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1ae964c8ce360684bfeddbabda54be80a3e332081c18f15efb8dd559a1295a"
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
