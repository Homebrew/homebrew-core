class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.9.tar.gz"
  sha256 "a824b49ddba9891512234f815fea39e9d80337dfe33cb3dd003d7a37e8061eaa"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c67bea2146d059a75a39360d2b1b56dfe33cbbf71bf6e550be6ec38573122248"
    sha256 cellar: :any,                 arm64_big_sur:  "0fae7e4f0ef86a9accf1e6f0adc29801a9f5666cf1ed11a45bdd38d3a76e4604"
    sha256 cellar: :any,                 monterey:       "106848f5c58fdd97736843097a23b2d0a05e5216b7545fbb2714687aa7bfc838"
    sha256 cellar: :any,                 big_sur:        "bbdff160b06309cc01f1415b39f67798215a6b9626183da4f198cac912403259"
    sha256 cellar: :any,                 catalina:       "a95cbe94bcd1359bbcee5ed638bb28506f08c403f0b653a5c6bb7dcc62ee1b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41472cca666e3d29c626cf073836993c4c44d4ae6b786d707e7d2dc86a49467f"
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
