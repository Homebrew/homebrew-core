class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a9094dfb85ccdde3cbb295f1086d4c71a20db1d26bf1d6c39f07a7d164033eb4"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71331f9fce25247c15fa2b8c38ff776c396bedec8f157e6a55b4a8a4df8a3bf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020d8b756ac7ec0fc1a3bc098585d5c51135ca16aab20ce1adf24e6c41322938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba83ebac1b5836c368e3b5b9409650a3a8b75afd13281066bfe9e3b66b5c6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b004e0e298b7cf38af96444ab2282d577595cd982176d143fbde704d22998354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd82274ea8b8c03b811de6db28adc8e3d313daf53b2fb3270046ce4277ed277c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f45074367bb109411982def1e757518d7ec77f2c22a3df5544d910226b92d8"
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
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
