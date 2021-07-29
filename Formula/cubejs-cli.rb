require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.9.tgz"
  sha256 "e146a0b970b4e8853da8b238adfed25a1af4be9569edc5cbb68d134da80892f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a1e7f2ec90b823a91b8a82584762b7f06e584f8bf28f76833a8a099135e3d92"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1315a7ef06f4cffbbbfbc0440fbc53f216aa64e7cb6fefe1d2b34f51ca89280"
    sha256 cellar: :any_skip_relocation, catalina:      "b1315a7ef06f4cffbbbfbc0440fbc53f216aa64e7cb6fefe1d2b34f51ca89280"
    sha256 cellar: :any_skip_relocation, mojave:        "b1315a7ef06f4cffbbbfbc0440fbc53f216aa64e7cb6fefe1d2b34f51ca89280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1e7f2ec90b823a91b8a82584762b7f06e584f8bf28f76833a8a099135e3d92"
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
