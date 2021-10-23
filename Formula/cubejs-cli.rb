require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.49.tgz"
  sha256 "67c8fff930e1989c23c9bc0fb18eeed411cfb2e058c754f025a5fed10de0c43f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39998e744b2f3b5325eab6f392d55da41ebb5f0ccbb404e9ab27c1a4f1b1a874"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fe07a35bf56e96e0831a261d88dacc45d7b1381e1a2e3f5ae0be49bc885f402"
    sha256 cellar: :any_skip_relocation, catalina:      "4fe07a35bf56e96e0831a261d88dacc45d7b1381e1a2e3f5ae0be49bc885f402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39998e744b2f3b5325eab6f392d55da41ebb5f0ccbb404e9ab27c1a4f1b1a874"
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
