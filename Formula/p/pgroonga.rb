class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.2.tar.gz"
  sha256 "2c121978b610efb50ee8919184fa69c06fff1c16af1502c77f37367817d06823"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "62030d327ee27e7851dfc83b507d4f0030bf22634c317f078ffd1ea656d9a44d"
    sha256 cellar: :any,                 arm64_sequoia: "39ec9f2e2ff6a9766dddff6afc9f44ae1e7545f56630e26e599e27580c3cc49a"
    sha256 cellar: :any,                 arm64_sonoma:  "e6c9a176b813fea1a12c778668da31b49135c3a53249392965f7d297aa815bec"
    sha256 cellar: :any,                 sonoma:        "7b2e0330558f191ca3b014f417b5d43347b2e7a929b53c6d5a23078df7f9379c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7347ac65fb4ae7bbc185c658a8e2d8916a5d284ab55ce1bc47a2d08c1597cc73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71d3c7351ac61b308a81ba762e0b2bdb956a4a2409b82e9e2f346eafb5de5e2"
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
