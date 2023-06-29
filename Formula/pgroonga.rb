class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.0.8.tar.gz"
  sha256 "dbf7489cb1bc8ac892247260372c606d4c0c77f9ad714271713bd29d5a4167d3"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e53effa2b5eeef8998414b5701d3ea2efc1f6a333aaf28cffa489164ef216f1"
    sha256 cellar: :any,                 arm64_monterey: "010468cef1151b99b7e6db8f40ea13fc03078d9db3c20d8dd5c4e658724c0972"
    sha256 cellar: :any,                 arm64_big_sur:  "6e7a16f7313f39418cb7a4ab51dfc4d74848f55c10d818f7d9c4246ff213f920"
    sha256 cellar: :any,                 ventura:        "87e219b851ce7b7c3734b8ac550511c1e86b4688201e5994299165e5de77d0d3"
    sha256 cellar: :any,                 monterey:       "51f6cc7277d9bf47c78efe4030a8fc1db0a842d42dda40b4136b4ad76944ff00"
    sha256 cellar: :any,                 big_sur:        "1e943f2fdfc99d769fd237236f78c68156e23bedf5c7e804ac3c4328502c8bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d67516ec7bf84855b14d3b0f99b2270434f1123a15f6980597fc1463953117"
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
