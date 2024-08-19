class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.2.0.tar.gz"
  sha256 "ce75cdb74935f9db499293997ed962f44146b741bc7f2131af69677ba653c6be"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06881d0894743c07205f196f2a100961bdf8294cc9b016261f8b3d6f09544d5a"
    sha256 cellar: :any,                 arm64_ventura:  "8ba31ecb015f23e24245fc39d5ba3f100092467c12b8e477a941da968bac649d"
    sha256 cellar: :any,                 arm64_monterey: "dd944fd2e07bc6d4e7fff8fdd99bcc4eb775dac86cb8a1c539c2c01d7f828448"
    sha256 cellar: :any,                 sonoma:         "67737282226a6fe5ca90c26885d62469a1b94514c00f97fa33edcef2eaea63d0"
    sha256 cellar: :any,                 ventura:        "6a8040812cf7050887e22a822c270c64f161e8add462fa5527333fbb45081953"
    sha256 cellar: :any,                 monterey:       "c9ce8a45f2a8f3a57c922f1e4685420d992fa0b0b9883425e04326b90ae41f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131714759dc573632659c4e9417de2874f283a8cd83b8bcda29076bfd672a6b3"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    system "make"
    system "make", "install", "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
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
