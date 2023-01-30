class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.4.tar.gz"
  sha256 "e5b29bfa4a2321a0ccc14b55d5156c3cb5cc03c08f7ec2d54ccc2212186292a4"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60dd745c24744ca80840a015026ee626587c9e0068a4244ce7e3acfc95df1d5c"
    sha256 cellar: :any,                 arm64_monterey: "0cc719b5510567910fe4e261059e7245ffe76262fc9c4c75f567fc693be5de9c"
    sha256 cellar: :any,                 arm64_big_sur:  "e3baca19270b957660ca5270df4c346b19b04a293176e789971bb8407326dab3"
    sha256 cellar: :any,                 ventura:        "5f685fdc6aa5cac975e5143e862e0957452dca8a21f82bc928b02b7500455e7d"
    sha256 cellar: :any,                 monterey:       "d08fd817d1541251dcab0b0f3b95f2d04da16a26c5135233d968ba9ee1df05df"
    sha256 cellar: :any,                 big_sur:        "3e4626bf73c212c0501bcdb16a94e410e82707747352d9608246c6312f583031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671e44c0a759a311da1cf5d17ec27c9a6c9256d452f20d0584b8af8caf198a1b"
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

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
    include.install (buildpath/stage_path/"include").children
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
