class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.0.8.tar.gz"
  sha256 "09509b7c23f29bcb00d8c769b222156a023ee7ddd896ee875b0a4acdcd657498"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be226018f10397f393fc94b08be1cb8aae94d4c0f03b09c05c4a559902bf3688"
    sha256 cellar: :any, arm64_sequoia: "43782ac2bec73ec954972ab95473a9bfa9e68cfe146b3a118b1c016a4c4ae403"
    sha256 cellar: :any, arm64_sonoma:  "f170aea63296b816880ef4dc7778d078a28fd4dd85ecf7c02aa26006436c92b6"
    sha256 cellar: :any, sonoma:        "1a1d445f5cf62200b3b0a3051cba3d7a5297818f140d1024955a2d5a8f66427e"
    sha256               arm64_linux:   "9eed0d181b97fe6efc875d6fb0b0cdbf649a8c41ad71f2b6feab6cc3975d7598"
    sha256               x86_64_linux:  "9d37fa0c32b65e643908f80a037168d5f477a42fbfc622c543c55bb2a4ea1945"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
  depends_on "groonga"
  depends_on "msgpack"
  depends_on "xxhash"

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
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"
        port = #{port}
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
