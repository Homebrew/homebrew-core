class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.3.8.tar.gz"
  sha256 "ff1967c2750c5bb26e51c4a76545789ea08572b7c60ef5d3a33ec82729070862"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "786d2ec770f7379d06ebdd02a27ba15ddd94b520d62f08164242be3a06cb78d0"
    sha256 cellar: :any,                 arm64_big_sur:  "7cbabdc28214687034ba0f08d6410fdf72fd7ed19d56ce49d5418883f7ee73aa"
    sha256 cellar: :any,                 monterey:       "51af8cd6918c054be1f8ec1bd57cb6dd672efbd9777365bcc6557e0fee4e3a42"
    sha256 cellar: :any,                 big_sur:        "6df0b40795cc926885d9c0f5665ada0a4baa04246d7fe2e046e757d726990f08"
    sha256 cellar: :any,                 catalina:       "3270a6bc852b2e74607efa80315a4194fe0011be5f2de885b20edacb7618f5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1cd9852b9b80ea70f01270fef748877c601f66a34ddcfe39328453192fd2f4"
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
