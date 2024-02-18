class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.7.tar.gz"
  sha256 "d778517bb9e8a16bf1d15850d5fbd9b3acadbb7d00c09141c031a301ac034412"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d203b4514fb4c37e92a9ca981722812b551d522628d530d082464269e08f71c"
    sha256 cellar: :any,                 arm64_ventura:  "72008d705f39e50912468d5a4d7fc267a78e29c12a374db5124381e27c0d4b9d"
    sha256 cellar: :any,                 arm64_monterey: "718271f1b81d75190bdbcd7c844c8bae0de417a0675a3bac5eef431df8e3f537"
    sha256 cellar: :any,                 sonoma:         "3ef1d37baeffff0f14e08446c3585c8d4efc035428e3aca1d0d993f40eb2c52e"
    sha256 cellar: :any,                 ventura:        "68c47d9847a1547e877f98a7b03d9623b60a9541d9c9d8592e1c6e91a89ed17b"
    sha256 cellar: :any,                 monterey:       "25bbc0eb4a55b38c138c82470d37a331fa3afc2eeac35f498a7a8f2e4fd07c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f004f4c8fdc33f1845471c7537e286ddb8fd4a55882c2efcaadc0fb6a843821"
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
