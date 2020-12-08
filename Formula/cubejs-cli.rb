require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.4.tgz"
  sha256 "bc3ee40c52cab8d46d07e7542a9ca1cab3b1cb262eeefa37b0041bdacc88ab69"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f862e3922110dc82fe93482e94f120806f809fa8cfde8c25119230fe0c88251d" => :big_sur
    sha256 "b3cc11487ff4adf6343b621d551f374fddca01de364a7dff707ee7109ee64433" => :catalina
    sha256 "acc35aead6590a0732ce74a362e0348c42beda4ead3025e847aa7fd26cd15a1a" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
