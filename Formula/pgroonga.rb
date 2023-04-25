class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.0.0.tar.gz"
  sha256 "58c52d0ae7ac32f2722da179096ea281b054673b010165b0e5e52620982b7725"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da8b0be667a518d75dfd89b5bd428d7ffc8cc9c4a745e5a7cf6419ba81b2506f"
    sha256 cellar: :any,                 arm64_monterey: "949b8e3569bc58d1eaef56c6ba56fa9cac2fb07e446ad5c96b8904ee5e3d2c49"
    sha256 cellar: :any,                 arm64_big_sur:  "fd4155a11d4057de8b7e34ef97b0a242009d6636df670f1c0d70a910849afdf1"
    sha256 cellar: :any,                 ventura:        "ee61a6ac36ceb13ee6bdc041e7d9f42adde3c499a7c979c8e9888b360b7e2d62"
    sha256 cellar: :any,                 monterey:       "be290bb2dae6f6ae375754b6d236ab086de8cd74711ed58e2edbeae78a2e3e00"
    sha256 cellar: :any,                 big_sur:        "e63cb4e743982a44368cb44d4a4be534eae4a4b1a805d11174a3175d369feacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74dbc3dc9a29748ece7cafaa6a395564e0c2af6ba855cee146300885b449fc04"
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
