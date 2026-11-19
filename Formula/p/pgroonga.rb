class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.1.0.tar.gz"
  sha256 "0ce8d58e73820bb74e82882afa58d6c0c5c46d43ae8349c6fc05c7097b85ee40"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7456e19a4e05a06577e76d33a1fe7d03e43751ed1fe228409e5122f27056234a"
    sha256 cellar: :any, arm64_tahoe:       "c6306ee1a33ecc9e370ee4378b7f5ecf0299693a6f2e97f32920b52f342d5f8a"
    sha256 cellar: :any, arm64_sequoia:     "19b670dc2329979ea9527e11e58b13be84e5eebbfee81d065a09dea21eae63c7"
    sha256 cellar: :any, arm64_linux:       "5871f25c697ac3d84cc79ed163a7c35077fd99abf0e6698712c0918223459ec9"
    sha256 cellar: :any, x86_64_linux:      "1f157121de9eb115b7e6bf90ed6fb284dda87cc230c85c261f157791f1828545"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]
  depends_on "groonga"
  depends_on "msgpack"
  depends_on "xxhash"

  deny_network_access!

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      with_env(PATH: "#{postgresql.opt_bin}:#{ENV["PATH"]}") do
        args = %W[
          -Dinstall_to_postgresql=false
          -Dtest=false
          --prefix=#{prefix}
          --bindir=#{bin}
          --libdir=#{lib/postgresql.name}
          --datadir=#{share/postgresql.name}
          --buildtype=release
          --wrap-mode=nofallback
        ]

        system "meson", "setup", "build", *args
        system "meson", "compile", "-C", "build", "--verbose"
        system "meson", "install", "-C", "build"
      end
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"
        listen_addresses = ''
        unix_socket_directories = '#{testpath}'
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
