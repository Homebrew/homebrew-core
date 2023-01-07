require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.35.tgz"
  sha256 "0f67c4c59dd103eeb9844d16509ee443f93435adf54a1c1b48c698ca52188563"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6443d37e9ff7edf4fb7003ade45ed0cd2f59ffb74a6d338b71696056cf725396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6443d37e9ff7edf4fb7003ade45ed0cd2f59ffb74a6d338b71696056cf725396"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6443d37e9ff7edf4fb7003ade45ed0cd2f59ffb74a6d338b71696056cf725396"
    sha256 cellar: :any_skip_relocation, ventura:        "fad13e0efe33c253ee9d60e91c4ea06d0c0d7f5503cafd6cb83ddecdf730d3e9"
    sha256 cellar: :any_skip_relocation, monterey:       "fad13e0efe33c253ee9d60e91c4ea06d0c0d7f5503cafd6cb83ddecdf730d3e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad13e0efe33c253ee9d60e91c4ea06d0c0d7f5503cafd6cb83ddecdf730d3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6443d37e9ff7edf4fb7003ade45ed0cd2f59ffb74a6d338b71696056cf725396"
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
