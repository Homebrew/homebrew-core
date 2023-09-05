class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-3.1.3.tar.gz"
  sha256 "449820eb0c9097d5f5605a7c7f529bc25a27673a0bb51e757db6effa6563713f"
  license "PostgreSQL"

  livecheck do
    url "https://pgroonga.github.io/install/source.html"
    regex(/pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a07afa71a1239256927917fb40ea6d6a525e8fd22208f5a74c860d22adab7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18224ee138215113a86920ecfa677013b3bd8ed676efc6daed52118c97ab6942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639ee17de0aae6f655e8efde15f9a7be3ce7534c8982d703d8904d4d0c8e1b59"
    sha256 cellar: :any_skip_relocation, ventura:        "fdcf21b9f7460db11ef68e49bd0a4558d86c78a8821cba7cdacd5ea02335109c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc030f8692da75ce32638541c8b65e13a6424bdb39784760ac7cc12084f407c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "75a5d8ed229baf824fc31f902bd244bcc56b9b0b23aec17ff282354df41c5576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47153df323d5cfcdf1350e9c09d716adb94a864fc650c147a08d3fee19a1fe6e"
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
