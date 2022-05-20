require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.19.3.tgz"
  sha256 "1109cd831c888a9578ce70211add2836e2752ccef71fda48611dcad771f1d5e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e383331174442d4614649ddbd6989f48062407b41284bed482e582babb3650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e383331174442d4614649ddbd6989f48062407b41284bed482e582babb3650"
    sha256 cellar: :any_skip_relocation, monterey:       "6987d2a900ef348a6af7e6f52ff65122f10fb0683acd0a9b820f9a9bbe69d95e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6987d2a900ef348a6af7e6f52ff65122f10fb0683acd0a9b820f9a9bbe69d95e"
    sha256 cellar: :any_skip_relocation, catalina:       "6987d2a900ef348a6af7e6f52ff65122f10fb0683acd0a9b820f9a9bbe69d95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0330aa7df0c29dc8a56d817e3804131623264214581ae4000d338307c839964a"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
