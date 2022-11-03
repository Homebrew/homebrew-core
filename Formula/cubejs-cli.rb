require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.11.tgz"
  sha256 "4d2602389f77bb0922505f6ed42d45a30b4f80a868b8071323bf39490205faac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f36b0df26cac2ace579384920279142cce6e28e33b6b1deb42cfab9f76902c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7f36b0df26cac2ace579384920279142cce6e28e33b6b1deb42cfab9f76902c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a078b3292c8b635fbdbf5f27065fac5964798e481154384d69a89a2012073f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a078b3292c8b635fbdbf5f27065fac5964798e481154384d69a89a2012073f8"
    sha256 cellar: :any_skip_relocation, catalina:       "1a078b3292c8b635fbdbf5f27065fac5964798e481154384d69a89a2012073f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f36b0df26cac2ace579384920279142cce6e28e33b6b1deb42cfab9f76902c"
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
