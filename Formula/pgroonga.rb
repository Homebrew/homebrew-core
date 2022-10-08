class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.0.tar.gz"
  sha256 "5baaae0e7d81f8167e278e9a34c6ed56aece8b34f5ab98f228c64408093417b3"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "007f54f9ae28a2efc856cf33c8bdc0bb4645cd7232728860bc676236c4f7f73d"
    sha256 cellar: :any,                 arm64_big_sur:  "e6c3326dc91812a851a505bf96e12f16aa9a8b9d86d12e6ab32daf1bdafe6474"
    sha256 cellar: :any,                 monterey:       "4063c04d3ae1f5ede9a35d1f1019e730e12629509bb29a7575c84902bb0b0275"
    sha256 cellar: :any,                 big_sur:        "1585328274f3f3b63da1bc747b1076e319ece9f2d9863eda2c940ece6b383040"
    sha256 cellar: :any,                 catalina:       "547bec8dbde41f36fa47d07cfb4a4d2468907156edfa0e0b049753382159df5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40166dd489081e30386ce26f4d518ad03a874edffffc4717fc305e0f00d64229"
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
