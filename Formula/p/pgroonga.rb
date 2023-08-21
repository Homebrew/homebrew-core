class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.2.tar.gz"
  sha256 "29a357415ca304ec3a7a23b96bb2aa32a57acc5c0ad7b6d8958f73322d305ce5"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cfd3dc8df238ece0c0b117e7664958fc021eac30e72ffc4a7c95910efe95ada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f4dc7270ee4054a8674b07c36033db86e109a41192a87684c690cfedabe8fe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42a1e1ef82c8febd1d269e9ab3dada93356ba4e30e4d2081e597c93ab3d04ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "46ac73400f99fc63bcfd76eb045b3b3ebc54df114354d011174f62b86ee613c6"
    sha256 cellar: :any_skip_relocation, monterey:       "f8faeb8e62e1162324951d530c8682bbc8b2e1d1890240baf688fef06c3df34f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcbc3559f35e9e0336ab943f4afeb123b9f1d892df26ff4925a27c302e631c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c1fd88381bbbef27e1c25e79429e332b7b4ab0f2dfc0da3122372ec4a50ab4"
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
