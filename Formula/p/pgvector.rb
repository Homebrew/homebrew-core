class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "fe6c8cb4e0cd1a8cb60f5badf9e1701e0fcabcfc260931c26d01e155c4dd21d1"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b793a57c62e893422fa7719ea057bec610e1cc1019e0000c27f24d605825b4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9efe1f228245dfd8f8a517a2f19f97687a22fc68d0596248b01b89a97e7e04b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ba8aeadec80a4671701420ef752712d74d649745ba9cb886032e46954c0fa1"
    sha256 cellar: :any_skip_relocation, sonoma:         "335f38c10171eedcf941064baa2fe88463ea00b2749ec8a938322861d0c18ee3"
    sha256 cellar: :any_skip_relocation, ventura:        "8a41315b83a2ab9ce401daf891836f73f3e0ef225eb3ed844d076a96f6200df3"
    sha256 cellar: :any_skip_relocation, monterey:       "c2f41a319d2e40a683e366000d663862de20dbdfbe64832658f157f259c1ac6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1220c7baf23fecbb5996e335aad442ab655d2160c4e661a927a117024667734c"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"
    system "make"
    system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    datadir = testpath/postgresql.name
    port = free_port

    system pg_ctl, "initdb", "-D", datadir
    (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", datadir, "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
