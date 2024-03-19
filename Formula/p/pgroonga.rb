class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.8.tar.gz"
  sha256 "5a38743492ba21f708df447b1ca0ac07ceff9715d9604aa2303f6dda795d096e"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5c242d5f5d71f4753c9439f04f40ae83cd472f85c22edffa119dd28d0119541"
    sha256 cellar: :any,                 arm64_ventura:  "b8f84320e9d0f5df47e944f6af8c750dc98ecbb5853c04e7bd88927cb1982601"
    sha256 cellar: :any,                 arm64_monterey: "47acb9e359d94bc1501c317a09d4d0d64a25b96f4fddaac5dbb49a44485a138b"
    sha256 cellar: :any,                 sonoma:         "6b001fe5bcc71a9b4fe94ede1c41afea0b1c4d1e6297859f4782f189463423f5"
    sha256 cellar: :any,                 ventura:        "f6e5ad70f205ffbdae792252d5c8db5fe491a1b25f77d4ae23e6a284710abf00"
    sha256 cellar: :any,                 monterey:       "90a3ee3f43b2bae13e1f9acedbab5a3df29b21087ca6ecf3394d7ce00fe0d7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31365547bc1813c084ebc42f10a020dacc9b88de2220d6d94ab84c1b31c4e4ca"
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
