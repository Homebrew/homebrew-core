class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "10bf9938906e5d643bbc4a7eea104b6f57ba4898e5b76b20e60484ea1d5a7f8f"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4163c0f061e78cb15e459d4c39979ec97037f45a7818f3d937008863f93358ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da33e6ae64b0ce9c244ca7a5d5206711b8c19394d9f344ed0a1bf495d95f92e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17a9c705680b773724ebcaff544efb9e14f1b06cd01a2e141abd1c9dec63240c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85fa44ed8ce583beff8e90c57cb87941b194814aa282714575be616ee113df2"
    sha256 cellar: :any,                 arm64_linux:   "6cf0a8dd44ec35fb95570c8c7406237521edcc12c76fd0c202bf562f0896b893"
    sha256 cellar: :any,                 x86_64_linux:  "78bc9bd004c9db2db6790176bab0881c1e3b8b8787ada07eb110d38ed9626a69"
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
