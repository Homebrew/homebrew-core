class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.2.5.tar.gz"
  sha256 "18cf44390b72ef685d13811cabc8e90ee76164b887de93fd3832f1b3c0d77126"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3462f62b63e699b6595a6eafd9efbcaa67e157efeb0b689e2ceb8b41b6e83248"
    sha256 cellar: :any,                 arm64_sonoma:  "9ab89f70eaf4596ae0330c4661ee16ddd5e9934832a0cb23ec4010c5b9a35626"
    sha256 cellar: :any,                 arm64_ventura: "74460b668a96abdd4364787d2a3b64b8362bc14d8116300d954c74a3871eca29"
    sha256 cellar: :any,                 sonoma:        "2ae03698602b5b630b1deab2653bad6806e373fc3199ef7dbf119513d750e8d9"
    sha256 cellar: :any,                 ventura:       "189587d2f7a88579c6ab53160d87c1bc998e2458a05135ef8b0611cd80e277fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae20f1dba259d7504dcca0e768aa91e1cb2bf1acc2cf52ceb6168c2dddb1148"
  end

  depends_on "pkgconf" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "groonga"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      with_env(PATH: "#{postgresql.opt_bin}:#{ENV["PATH"]}") do
        system "make"
        system "make", "install", "bindir=#{bin}",
                                  "datadir=#{share/postgresql.name}",
                                  "pkglibdir=#{lib/postgresql.name}",
                                  "pkgincludedir=#{include/postgresql.name}"
        system "make", "clean"
      end
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
