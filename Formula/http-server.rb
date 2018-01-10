require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/indexzero/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.11.0.tgz"
  sha256 "fd932adb32fe7c03da7ef45c71a08a088ec7d6472db5906694c5a1962541e5c1"
  head "https://github.com/indexzero/http-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8466d02ddb4943da343aead061c89112d20436937f001f8b4253eb2160c749e0" => :high_sierra
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
