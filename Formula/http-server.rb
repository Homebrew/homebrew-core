require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/indexzero/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.10.0.tgz"
  sha256 "cf7bde2def672698f78463ce8bec54dfe6392c24552f2b1c5e2e5ce94428de23"
  head "https://github.com/indexzero/http-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "232e9b864df77fb42296b9c0a065ae998d47c227700b6f969344228df2ceea5d" => :sierra
    sha256 "19539364bfc94381abc86b2920bd2400bd6ea25e25f782a3491f51cfd0b2f632" => :el_capitan
    sha256 "63dc26f7b77915ed23cb96bdbbf23ecc9d3dbd6ac5fc72c168de8d1fa9217e83" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/http-server"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
