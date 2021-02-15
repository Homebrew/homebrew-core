require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.14.tgz"
  sha256 "8b6bb31b4a2f9f063d50ad48a456d6ffc3b4196238d4a4bfbf1776858d5db890"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e824ba99384d0a8481b2896c60f065c49e2b7885bd561ed4b791d0062eba9f9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "488d82685dc56ee25471df5adab33486888f762c17d54af7ae0a3608dac25dd6"
    sha256 cellar: :any_skip_relocation, catalina:      "c3406a1730653f7c87c4f3f883097a9941912a8b8acf437e3e409d3dcb8679b3"
    sha256 cellar: :any_skip_relocation, mojave:        "b77bc60ddd4f120234565b834050a331823c46b5542f7607a56bc648470460d8"
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
