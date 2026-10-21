class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-4.1.0.tar.gz"
  sha256 "0ce8d58e73820bb74e82882afa58d6c0c5c46d43ae8349c6fc05c7097b85ee40"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89f79fe5cfa2adda9e83ddffa9375c95c5af62ed6fe08c0330a91d057469814f"
    sha256 cellar: :any, arm64_tahoe:       "d844291254bd3e72c344e4ace12b392842b06fd619ed6f605bd865aadbbc57ec"
    sha256 cellar: :any, arm64_sequoia:     "1df0d30ff3abd192dc67f97d7fc5494d8f8f5b4c37429af16156a348602f26f4"
    sha256 cellar: :any, arm64_linux:       "9bd0cfa92ca4b32d3e14d50dfcd7a094fa71d3eb105fdc27f825485921404ac3"
    sha256 cellar: :any, x86_64_linux:      "8ce9d7526b1179316c5e9dd81207f40fc2321bb0e0f3f9c651f85850a706a40b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
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
