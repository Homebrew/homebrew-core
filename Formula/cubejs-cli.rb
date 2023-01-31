require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.56.tgz"
  sha256 "ea19a29a80c6ecb1aaef30bef62238d0328317c1e50d35cb8cd72aa33c206f09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e173fe9836c660542ac5c27f8d7da789f30ae1f805f9bdcc6e924bc1ea63af2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e173fe9836c660542ac5c27f8d7da789f30ae1f805f9bdcc6e924bc1ea63af2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e173fe9836c660542ac5c27f8d7da789f30ae1f805f9bdcc6e924bc1ea63af2"
    sha256 cellar: :any_skip_relocation, ventura:        "ec92ed91227bd3f5aadf612689c7c60d15c8a051bcb3b7818f3f70a5928da588"
    sha256 cellar: :any_skip_relocation, monterey:       "ec92ed91227bd3f5aadf612689c7c60d15c8a051bcb3b7818f3f70a5928da588"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec92ed91227bd3f5aadf612689c7c60d15c8a051bcb3b7818f3f70a5928da588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e173fe9836c660542ac5c27f8d7da789f30ae1f805f9bdcc6e924bc1ea63af2"
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
