class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.9.tar.gz"
  sha256 "d18eca2df804c0448a8c60dc3db4b9f81ab2cbd3aede4d4c48e172009463feb9"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d670d12b9efd7f2f75469132f6e06788635ca71684b75b6f5d1da5029b806cd2"
    sha256 cellar: :any,                 arm64_ventura:  "c552a37d2edd3668c3f016eed3f48998d4fa21f0679c1d62ebb82785e2324e3c"
    sha256 cellar: :any,                 arm64_monterey: "5eaa589af7d652994493971b5b6dd74699b14d32a9391c9273efe7c52197d037"
    sha256 cellar: :any,                 sonoma:         "4ddb72d3656db5ad64754f3184b31a63530fd9da171e4a9fad594c94a21f10b7"
    sha256 cellar: :any,                 ventura:        "aecf45827e08aa5383bc9844736f14248f8b25c38d469097e962deaa2ba2d23c"
    sha256 cellar: :any,                 monterey:       "9c1f41258688849d30f7b95bca6bc7dd7165d04e3bcddcf97e6e96f178511f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e18e042c3a3f59d0f794db4c8ec360da6bb042db230a34ba08a3152465cbab1f"
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
