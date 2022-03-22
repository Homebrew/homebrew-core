require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.34.tgz"
  sha256 "0b70dbbfc3ec5b96138f666fb929b81ad9d7dd4fed409c57812a8cbed94dbdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ae29f14f2727a5e5fafa7f58ef1c6f5ec829f020120442447c297a05065bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86ae29f14f2727a5e5fafa7f58ef1c6f5ec829f020120442447c297a05065bda"
    sha256 cellar: :any_skip_relocation, monterey:       "913058301ec3e5a62f9229d488968251411ee7fd9dfc92ed9167a68325c58b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "913058301ec3e5a62f9229d488968251411ee7fd9dfc92ed9167a68325c58b4c"
    sha256 cellar: :any_skip_relocation, catalina:       "913058301ec3e5a62f9229d488968251411ee7fd9dfc92ed9167a68325c58b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ae29f14f2727a5e5fafa7f58ef1c6f5ec829f020120442447c297a05065bda"
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
