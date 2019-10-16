require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/indexzero/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.11.1.tgz"
  sha256 "4154aba3e09f21595e26fdd174d9773e22755c0009f661bed54b8647fc987d95"
  head "https://github.com/indexzero/http-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "324d8d125e41d89b6522d89b431fdd5a58ddfbf974a41272971cbb1bb7eb7d0b" => :catalina
    sha256 "755716ac31e2feb72c2ce6a27d68175e751850cf1c28cccc3f96fc09bd2a3a6c" => :mojave
    sha256 "d6a7324d5ed8943d3a63cd570346169206163879dbc9b347f584031ee9423a4a" => :high_sierra
    sha256 "0a693d35ecd6e30295a3c714b51c02fe37dd1b0fba63107fffaecad6827f6850" => :sierra
    sha256 "8d34e825aededd73ab87420e53a537742998f578f0019ddcf7eae9b8d8f6dd55" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
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
