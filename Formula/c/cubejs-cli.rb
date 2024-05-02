require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.26.tgz"
  sha256 "d8c12676a2e5e60ae0310343dd061163a9432a3f54ff6dd428f0d1f3d62d650f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "734a1abfa770dee89b2c31d3463acc5448be145543619993ce6798ba872cb0f4"
    sha256 cellar: :any,                 arm64_ventura:  "734a1abfa770dee89b2c31d3463acc5448be145543619993ce6798ba872cb0f4"
    sha256 cellar: :any,                 arm64_monterey: "734a1abfa770dee89b2c31d3463acc5448be145543619993ce6798ba872cb0f4"
    sha256 cellar: :any,                 sonoma:         "6d97245b23fa25804b3ab551cac85e2055b4fbd14db0fea0f22a8ac7d7adddf8"
    sha256 cellar: :any,                 ventura:        "6d97245b23fa25804b3ab551cac85e2055b4fbd14db0fea0f22a8ac7d7adddf8"
    sha256 cellar: :any,                 monterey:       "6d97245b23fa25804b3ab551cac85e2055b4fbd14db0fea0f22a8ac7d7adddf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3dc43d0f746039d55da340006a860f4ec72cd7b36529ac9a6a39a4f0ed35c4c"
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
