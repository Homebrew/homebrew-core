class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.14.1.tgz"
  sha256 "131cb5c572c68a42a6c612b65041a4fa656a5364a75f7384f1446f62a684c9fc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "50536d0d0000e441a09373ba89a497efda82318192103e59f212814dcc3ee20b"
  end

  depends_on "postgresql@18" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["LC_ALL"] = "C"
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql@18"].opt_bin
    system pg_bin/"initdb", "-D", testpath/"test"
    pid = spawn("#{pg_bin}/postgres", "-D", testpath/"test")

    begin
      sleep 2
      system pg_bin/"createdb", "test"
      system bin/"postgraphile", "-c", "postgres:///test", "-X"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
