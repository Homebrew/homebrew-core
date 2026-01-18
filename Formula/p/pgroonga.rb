class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.5.tar.gz"
  sha256 "8fb7f0e559525594b7f2b20eae4495925c842ab86b3e09e256abfdc5be793133"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2f47f7e90efb15b9f07a65039b8da6928ba54f2fc9de435bc9a7528970beafd"
    sha256 cellar: :any,                 arm64_sequoia: "1d591f10d8b95669300cf96addbb80d7a4e0d1b488cf365aa0e547bed010fc0e"
    sha256 cellar: :any,                 arm64_sonoma:  "23bfaec1f848ebe7917c91051b76c7594fcb08264c574ec3bbbf20dc1ba5ad74"
    sha256 cellar: :any,                 sonoma:        "a37d21569aec5730eb2b83c5d78a4a26077ca44d15ff028081e515c21081c292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b3138d9ff12939d75e17a1d7425d50a259f5048b6330116bcbf7a3df166c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60269dc50f4ea28b4e35c57e0b560cbc4537d7b39774f201a57b4e8523793c8c"
  end

  depends_on "pkgconf" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "groonga"

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

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
