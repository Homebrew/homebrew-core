class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://github.com/pgroonga/pgroonga/releases/download/3.0.6/pgroonga-3.0.6.tar.gz"
  sha256 "d35779a47ed02bbda8aedb5b7a54f3ab0a43052f7ea986209fb71cf6a199fd12"
  license "PostgreSQL"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d71ba728059fb6f4427857e76ca2b182e47bce2e5eb526c5effab404c1e99b41"
    sha256 cellar: :any,                 arm64_monterey: "41a847a945af7c21935dba1b0314ce5e81a1934945c3cae5ddc3d1c1c1c40904"
    sha256 cellar: :any,                 arm64_big_sur:  "c52dada123330f7144fcb91bc04c30640460611f20f47433ccaf9721cf126547"
    sha256 cellar: :any,                 ventura:        "49c6e21e7a9acccfb063711f769036b2bcbb8479984e4acf535e136158027123"
    sha256 cellar: :any,                 monterey:       "5aa81a0de5910c90049414cef9007ef4b67af16e23f297043b7eac2df027a378"
    sha256 cellar: :any,                 big_sur:        "37576f653c00b469dc7e6c2a744f1b8fb3f7184b647165bc702c59f1de7eaeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4c8e2fa5e667c9fa0f4fca437b2d097ceba7fb58aa68d86a44554728b82185"
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
