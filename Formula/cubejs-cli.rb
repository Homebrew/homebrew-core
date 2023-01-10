require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.37.tgz"
  sha256 "b4b2c91e87bc6f1961f11e56d5b25aa2cfa5d547c285700b7fe12413cf51bc41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f94f5369379774e2129835b14a23ad502a3d493b372bcf00fd273307325a990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f94f5369379774e2129835b14a23ad502a3d493b372bcf00fd273307325a990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f94f5369379774e2129835b14a23ad502a3d493b372bcf00fd273307325a990"
    sha256 cellar: :any_skip_relocation, ventura:        "8ea747f88ec19c647e4749667e38397dc23573c4ff0ffad61105f1bea33a9dac"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea747f88ec19c647e4749667e38397dc23573c4ff0ffad61105f1bea33a9dac"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ea747f88ec19c647e4749667e38397dc23573c4ff0ffad61105f1bea33a9dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f94f5369379774e2129835b14a23ad502a3d493b372bcf00fd273307325a990"
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
