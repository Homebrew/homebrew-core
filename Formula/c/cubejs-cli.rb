require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.57.tgz"
  sha256 "ffef0661b09fc1b7323643b653068ff834dfc08c852914f2331d6e2d1c9b8946"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "97eef3874ce0b9c1d75c718a05d48ec3c0008f2671cc589217463952460fce9e"
    sha256 cellar: :any, arm64_ventura:  "97eef3874ce0b9c1d75c718a05d48ec3c0008f2671cc589217463952460fce9e"
    sha256 cellar: :any, arm64_monterey: "97eef3874ce0b9c1d75c718a05d48ec3c0008f2671cc589217463952460fce9e"
    sha256 cellar: :any, sonoma:         "0986a6608705094e46cc84975a2dde15da4f07dce0b53594acd3c2d2e52cf52e"
    sha256 cellar: :any, ventura:        "0986a6608705094e46cc84975a2dde15da4f07dce0b53594acd3c2d2e52cf52e"
    sha256 cellar: :any, monterey:       "0986a6608705094e46cc84975a2dde15da4f07dce0b53594acd3c2d2e52cf52e"
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
