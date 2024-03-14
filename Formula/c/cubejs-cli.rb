require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.0.tgz"
  sha256 "d778c058410518c6b581ea3d798ce85c42467e70bf3ec5e018696a94ee76b90d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6815a0799daf2d1197d556e57ea00537f210b67e1e8d2c7890a728e689458174"
    sha256 cellar: :any,                 arm64_ventura:  "6815a0799daf2d1197d556e57ea00537f210b67e1e8d2c7890a728e689458174"
    sha256 cellar: :any,                 arm64_monterey: "6815a0799daf2d1197d556e57ea00537f210b67e1e8d2c7890a728e689458174"
    sha256 cellar: :any,                 sonoma:         "3daffe790b423e58ca38a697a518479d8c37acffbb865a7f1def9157850d03f6"
    sha256 cellar: :any,                 ventura:        "3daffe790b423e58ca38a697a518479d8c37acffbb865a7f1def9157850d03f6"
    sha256 cellar: :any,                 monterey:       "3daffe790b423e58ca38a697a518479d8c37acffbb865a7f1def9157850d03f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af35d3c3b10c228e8117dc4a4808055a8af20fe7fcc652e02f1cf27676fe09aa"
  end

  depends_on "node"
  uses_from_macos "zlib"

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
