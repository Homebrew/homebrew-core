class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.14.1.tgz"
  sha256 "131cb5c572c68a42a6c612b65041a4fa656a5364a75f7384f1446f62a684c9fc"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b4305806f3dfd7348eae61c3dcd47b8d33e353becbeb00c917ec745e4851b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b4305806f3dfd7348eae61c3dcd47b8d33e353becbeb00c917ec745e4851b1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b4305806f3dfd7348eae61c3dcd47b8d33e353becbeb00c917ec745e4851b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0403af0d6526117f1d49c548adf246a011abe313b30e4b41261b76dae90c79"
    sha256 cellar: :any_skip_relocation, ventura:       "3f0403af0d6526117f1d49c548adf246a011abe313b30e4b41261b76dae90c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4305806f3dfd7348eae61c3dcd47b8d33e353becbeb00c917ec745e4851b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b4305806f3dfd7348eae61c3dcd47b8d33e353becbeb00c917ec745e4851b1f"
  end

  depends_on "postgresql@17" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["LC_ALL"] = "C"
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql@17"].opt_bin
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
