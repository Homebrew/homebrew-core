class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a9094dfb85ccdde3cbb295f1086d4c71a20db1d26bf1d6c39f07a7d164033eb4"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c264eeffe1086c33dbe07d1c3cbe33ff8ac4f658969d8010213cd05c885d54c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01dff5d03be54305b71a6aac9eaaf3fd5e4d1f315ed0fa1dd830aebdf5e75746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7e99e6267e9e0686af80ccab22c764b1010cbaeaf2c026ad591a41c0d7fe870"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef33203fe058a76976309bac1bbec7ca55e352241eac2f74f71621466533d977"
    sha256 cellar: :any_skip_relocation, sonoma:        "92462244cffe391b566a0eae47a7cd5c48d43b4d4b2708ae4d54b9e8d2a52b2a"
    sha256 cellar: :any_skip_relocation, ventura:       "04e8b84a206d48f8622d53ff2021373b81356d6c95104f6d49399656602b4784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a6fa66bd919c746f9d58432fc43982bee2f4d3eb0cf197715fe997f4293071d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaab7b23e670c2db2ba871a2130001c2ee7448d21e0911b7b28d68fa0ce1c78a"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
