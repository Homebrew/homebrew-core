require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.59.tgz"
  sha256 "b012706e37ea38201d93427ae36575f1e97d53c1573c7f4bb99097baea5ea15a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "432e9f12353b4d9fe0461d70e1964d3d82a65cb730bfee6463ce3e66b17ac958"
    sha256 cellar: :any, arm64_monterey: "432e9f12353b4d9fe0461d70e1964d3d82a65cb730bfee6463ce3e66b17ac958"
    sha256 cellar: :any, arm64_big_sur:  "432e9f12353b4d9fe0461d70e1964d3d82a65cb730bfee6463ce3e66b17ac958"
    sha256 cellar: :any, ventura:        "eba6b960e49601d9018c05d8b5a24e48cc89ce3de24d6d865737ed6e949c325b"
    sha256 cellar: :any, monterey:       "eba6b960e49601d9018c05d8b5a24e48cc89ce3de24d6d865737ed6e949c325b"
    sha256 cellar: :any, big_sur:        "eba6b960e49601d9018c05d8b5a24e48cc89ce3de24d6d865737ed6e949c325b"
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
