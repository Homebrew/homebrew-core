class PostgresqlHll < Formula
  desc "PostgreSQL extension adding HyperLogLog data structures as a native data type"
  homepage "https://github.com/citusdata/postgresql-hll"
  url "https://github.com/citusdata/postgresql-hll/archive/refs/tags/v2.18.tar.gz"
  sha256 "e2f55a6f4c4ab95ee4f1b4a2b73280258c5136b161fe9d059559556079694f0e"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2127db4c57a1859e589e8d6b073846c921403023651fa7b7dc307976555bd0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68222bf3940f01f6e0fdb678793550e891216642508fda81c9d00399829299f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99fef7555b3537c04f99342845460b847e89986f7cb48f6f66365734cd3aa2ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecbb627cf1d27c957afb6cdb6f7a3ecc7249ece09ff377686d7c1b6eeaa26fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "538f2f44bca1e662c992bbc06a506159aaea51a1c409da1ed1eea86e863f688d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f63b4a80e968c0633065248096e6579ab64aba28a8f6f04ea6633a72d85565"
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
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION hll;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
