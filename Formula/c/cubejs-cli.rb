require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.49.tgz"
  sha256 "89ed8646b76cd44dfda5e62271d0e014ef84f0d0a5c1eeb8fa644101e7cf55f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "39180162683d91b2a8b204a475f5e2902555dfa8aa390c7d807b15a16ff02160"
    sha256 cellar: :any, arm64_monterey: "39180162683d91b2a8b204a475f5e2902555dfa8aa390c7d807b15a16ff02160"
    sha256 cellar: :any, arm64_big_sur:  "39180162683d91b2a8b204a475f5e2902555dfa8aa390c7d807b15a16ff02160"
    sha256 cellar: :any, ventura:        "5d0714fad7112352ce41944ab3970f6d338739bc801ef38ba6bd254a5f1fcd65"
    sha256 cellar: :any, monterey:       "5d0714fad7112352ce41944ab3970f6d338739bc801ef38ba6bd254a5f1fcd65"
    sha256 cellar: :any, big_sur:        "5d0714fad7112352ce41944ab3970f6d338739bc801ef38ba6bd254a5f1fcd65"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
