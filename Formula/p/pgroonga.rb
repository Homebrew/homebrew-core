class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.4.tar.gz"
  sha256 "2e7be664ee99b49dd23ec57b19403ff4f5b44ca21d3c039d43fd1d550d583223"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0280838e8535f93baa721a29e8460236ccc523f3ed77559be4118614e11020f9"
    sha256 cellar: :any,                 arm64_sequoia: "13d674ccdd0c2d03a70c464813b38ab52b70a9108e794f982ba3fb3d11cb1d1f"
    sha256 cellar: :any,                 arm64_sonoma:  "655deb7c692416f35a2b940032d621baa2aacc592132f307406fb29d1dfb6de7"
    sha256 cellar: :any,                 sonoma:        "7bcc4ccff48fea432c7abd064ece44ef19c897d79e3879815f19a0ac091ca228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a8415656c1963cdfc8d6659de98eb4d568f3f73dfed71cb2570b7073eee26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6bf1ac6a1df6292a061fdc48796b3c1e1bbce6e20e7161704258c8971b5eba0"
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
