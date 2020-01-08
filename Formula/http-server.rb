require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/indexzero/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.11.1.tgz"
  sha256 "4154aba3e09f21595e26fdd174d9773e22755c0009f661bed54b8647fc987d95"
  head "https://github.com/indexzero/http-server.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "665fb079e61a54404b0cca165221606a3e4eaea7e0e8dbb3d09868402d67d1b5" => :catalina
    sha256 "73f8bae1002efba8e3799e5f0394831dd79b53b264e0581cfac6f8ab8ee58002" => :mojave
    sha256 "346263e7a818fbaeeb2dfc7dee4e57b908bb2eafcc407609ce3ca336b47132ba" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/http-server", "-p#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match /200 OK/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
