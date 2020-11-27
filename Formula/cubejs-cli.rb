require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.2.tgz"
  sha256 "947262321a72f80b4660e7abd80f596bbae5934950cd0b8a05493c56d8a1758d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "098d50e74f3498b70975c5e1b23103558cfb96dd9f5b03866c6f290289a96cdf" => :big_sur
    sha256 "61a07d80900cde7292fa7753f1e01dd2f45f446d83e8db01327b68ff4a8fcf55" => :catalina
    sha256 "4050e1dbb4119be7bdfafb22c259be4fca34a54532d4f4c8ba301dfd8adaaa00" => :mojave
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
