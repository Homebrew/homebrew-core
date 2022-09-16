class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  url "https://github.com/citusdata/citus/archive/v11.1.1.tar.gz"
  sha256 "fa678e03d633467379448cbd64fca89f70a0653b0b26745a38ad64bed1ed2cff"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b100d270c5592ff2b31fe164fe52574f92bfde8a0be940033dad3dc7bb46a40"
    sha256 cellar: :any,                 arm64_big_sur:  "91ff724e488baca4d611e5370ba17e4c809883d0fb6dc270dc296c0e3abe3867"
    sha256 cellar: :any,                 monterey:       "186d97c45e8918e40feeb65b51ba4562515dc032ddb099ce03b664c4be2e07f8"
    sha256 cellar: :any,                 big_sur:        "e9237364eb50e0228f5bd699b9dc9a5f1854f94ce3a7b40c43e037cef5ea2b56"
    sha256 cellar: :any,                 catalina:       "29d036d72f03db70589b736fa5c11759c60fec3b627efbfcf503049864d45a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76b4de2742d1664e46b153f20dde07e2bb98914b51b4121fdac7524448cbf21"
  end

  depends_on "lz4"
  depends_on "postgresql@14"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "./configure"
    # workaround for https://github.com/Homebrew/legacy-homebrew/issues/49948
    system "make", "libpq=-L#{postgresql.opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    include.install (buildpath/stage_path/"include").children
    share.install (buildpath/stage_path/"share").children

    bin.install (buildpath/File.join("stage", postgresql.bin.realpath)).children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
