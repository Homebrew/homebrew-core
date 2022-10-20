class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.4.0.tar.gz"
  sha256 "5baaae0e7d81f8167e278e9a34c6ed56aece8b34f5ab98f228c64408093417b3"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6faf0edd4b53c4d602b8e5db36b9f210ea51b15c4df0d2f6ff4a23e7853a15d2"
    sha256 cellar: :any,                 arm64_big_sur:  "6209bbe204efd0141b109f65e725908a868231d2ab6df9758b231d9d33752288"
    sha256 cellar: :any,                 monterey:       "cfbe08b09d9e4d74a943dff7b74205e4345fb861232799920e15e3aa30382e56"
    sha256 cellar: :any,                 big_sur:        "710eafcf3f7ca7537fe3b98df9f147ca929f18ca2f3ee045990b61144d8d6c3b"
    sha256 cellar: :any,                 catalina:       "45b281518fceab073f535d135db359b7433fbb782fb3827a68e6cc8f547fd749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11606d74f3019683b55d1e744462ad09d1a790a69613465ce54ba066e56fd8aa"
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

      shared_preload_libraries = 'pgroonga'
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
