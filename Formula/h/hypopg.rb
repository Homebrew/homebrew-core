class Hypopg < Formula
  desc "Hypothetical Indexes for PostgreSQL"
  homepage "https://github.com/HypoPG/hypopg"
  url "https://github.com/HypoPG/hypopg/archive/refs/tags/1.4.5.tar.gz"
  sha256 "9d1981af0c55ac75ab4e2648e0050ee626c1af4c68b24259e3c744ff5211ce49"
  license "PostgreSQL"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b954ed4d58f62479760b40c1f93028dbfda260db948249d1c4e8b30285f5d3a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb28c5f0d1ae0025fcfb7f0d7f4894b534e62f3c3e66a723483f3b58938e9821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bf2150e57cf13e319df155b5ca5246ebf0c0f1170ee3f0bb8d2980936208651"
    sha256 cellar: :any,                 arm64_linux:       "7926b105c30554364a92b68585a98b0cf71d45bc23e7dabdeeb53fab67e368b7"
    sha256 cellar: :any,                 x86_64_linux:      "c46c73209be897e795c938d4018d61c162145e61051fc3be2780fc59ff4c9742"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
      system "make"
      system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}",
                                "pkgincludedir=#{include/postgresql.name}"
      system "make", "clean"
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
        unix_socket_directories = '#{testpath}'
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-h", testpath, "-p", port.to_s, "-c", "CREATE EXTENSION hypopg;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
