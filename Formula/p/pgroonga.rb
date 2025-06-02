class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.1.tar.gz"
  sha256 "e2dfe40f3a0342e9ce4f1212043c46564fda3678e8cfda8587bbc37b103ebd17"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa5b5427b783ffc3883f0c7bed63cfa61523ceb262dc8f12828d556744ad1173"
    sha256 cellar: :any,                 arm64_sonoma:  "4099e0f0a91fc915c153d9065418c6bde0735c33918a553b060b9e72b7d91615"
    sha256 cellar: :any,                 arm64_ventura: "566650be1da201e6b58e18550dc401de99f37ea306fbc9594e996b6609a1eba2"
    sha256 cellar: :any,                 sonoma:        "bb3eb6dc07a7dde21c8425cc50a384a345a2d3af35e06e8048763701ce89be03"
    sha256 cellar: :any,                 ventura:       "ac024d77294e071078565678f948821774d596b97152f8d660c547bfdde11b44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95b94358412a53dc2f15df1f277953581a1a4d2a3ae526b1553c6ee0fd0d29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3a3e602ca372150b2c8b9d3ae993fef0434fd9a86bcea549335c37bd2cd38b"
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
