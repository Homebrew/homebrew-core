class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.2.4.tar.gz"
  sha256 "591aa7cbd4920e01211c0a74e36e6b286aa332d55892615df1c389eb66fd5bff"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7dee11d56208c67b9beafece4b6a7c7404da6dfa676886360881b90bf91e5679"
    sha256 cellar: :any,                 arm64_sonoma:  "2158f0b6232901d491cdfaa4711379b96c4c62015d1c229706b0421362703c26"
    sha256 cellar: :any,                 arm64_ventura: "ec4693dc5b4f3cd0c6f1cfdd3080537491bc5b7a5c4f4ef202fb88c8cf12dc5a"
    sha256 cellar: :any,                 sonoma:        "7aaa568304d039b29b0104586c6bc059ba3ea6b2786908a3e2e55a3cfbd6b1b9"
    sha256 cellar: :any,                 ventura:       "3c40a14775b2b5f4caba6baeec0717e64537294d697c5b5bf709ef111b3c010d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97e067ef693da8269ef9fccfee8f787704dc019714b4637b723d481d8e050b32"
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
