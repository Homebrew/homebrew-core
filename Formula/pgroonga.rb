class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.7.tar.gz"
  sha256 "b116cc3f2c96a23ff197619fd72b46e7b64e39e3fa1cbb1454f483aa1db607e6"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33ac3a412ecda9e790dfd3956caad5051166d99301dd473d434cff8782466955"
    sha256 cellar: :any,                 arm64_monterey: "54f48d1f03a8987de38103e6ddb091db2221c257bff9dad69342fd3652dcac32"
    sha256 cellar: :any,                 arm64_big_sur:  "69f0464c1fc266d33a46daeba0afc1e2b0a09370bbe8a304ec3138c166ac1671"
    sha256 cellar: :any,                 ventura:        "016b9c9f26829718b6b54ea03c14bc892b58093944f694b6ed2136a8631b551d"
    sha256 cellar: :any,                 monterey:       "e2b7ee533c4adf25f754894772fa77f86a72b68bae1bab270f5068d99313370e"
    sha256 cellar: :any,                 big_sur:        "3cb4b9ef822df08f4070adabf35f2cbc3aba4d6e7c5ee8bb0b106953828d2520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0003684ef9e3936b1d760f369770edc801ad7e7884797c0250dce32bf19697ac"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    relative_pg_opt_lib = postgresql.opt_lib.relative_path_from("/")
    relative_pg_opt_share = postgresql.opt_share.relative_path_from("/")
    relative_pg_opt_include = postgresql.opt_include.relative_path_from("/")
    lib.install (buildpath/"stage"/relative_pg_opt_lib).children
    share.install (buildpath/"stage"/relative_pg_opt_share).children
    include.install (buildpath/"stage"/relative_pg_opt_include).children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'pgroonga'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
