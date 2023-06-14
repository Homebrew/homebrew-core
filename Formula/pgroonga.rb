class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.0.7.tar.gz"
  sha256 "885ff3878cc30e9030e5fc56d561bc8b66df3ede1562c9d802bc0ea04fe5c203"
  license "PostgreSQL"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "671996744d342ad2c2ffe9985db7580c4fc556514afbd3b87974e3f508e4f539"
    sha256 cellar: :any,                 arm64_monterey: "7dcbb4748f7ceaeba5a2f019e71ef34ab2ed8ce6edb3c15e233b09d392528a2e"
    sha256 cellar: :any,                 arm64_big_sur:  "7459e39ce50d33906f6be67b9be99cde49518f42461540a5e65ff0c13b243e9d"
    sha256 cellar: :any,                 ventura:        "b9f79eb4dd55bb1caf2d9162f35cbd8608f87ddcca502528cf929129fc3a3e4f"
    sha256 cellar: :any,                 monterey:       "19eef6356f96f61064aa7e8f2d1cb1accf2bc1195aa806aa26e6bb93be6b18cf"
    sha256 cellar: :any,                 big_sur:        "9eb6e9be96f588b905ba5ab542f0a18b80352b0404e1cdc34682ea105bd981c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba62b0c89879395ab02bc3a869ffc84458a9821be7c8e60ae5fae028a72917ac"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
    include.install (buildpath/stage_path/"include").children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgroonga\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
