class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.0.tar.gz"
  sha256 "fd020a911ec223f5288e99131c91abb437a9a0aa9d5e51b8fdb96d633bd61fb9"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e9ffc1738461299336b04bc331c38746a1e72cefeabb592d793b2e3d6ac80bd"
    sha256 cellar: :any,                 arm64_monterey: "5c30c241f102739e410d56abb0ea338a9951c3385ee5576d70bb7ca5eed94518"
    sha256 cellar: :any,                 arm64_big_sur:  "7cede888c28c4fbc3180c9e7786033bbfab3abd2857b4b03e5ec5a90f27186dc"
    sha256 cellar: :any,                 ventura:        "6ebe8dc446aca07de7b87b201171391808bb7a53003eb3bb54001310c092d7fd"
    sha256 cellar: :any,                 monterey:       "a0d70924cb08c92a6917a89be13b412d6bdffff34dd83d018289c587de0bc67f"
    sha256 cellar: :any,                 big_sur:        "f3ece69b7367719576fee7e447ab6ff05aaa43282daa08acdfe78fbb0bc8ea59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85cb79ba74ab8b7eb19000d13ba17d84a3f3bca2c181b2e6a3e1c6ff5b97c54b"
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
