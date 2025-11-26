class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.8.tgz"
  sha256 "96205c8014488234c6086ae87b6cf873d3e833de6d9332e7a93d477f19ffed2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bd4ff1f7803972d9eb06075c5a94ea8245047f5113d2fcb4dcda453185d886f"
    sha256 cellar: :any,                 arm64_sequoia: "3e68081749bde4dd1c92f809063005fd48f182a0ea1ee097c6910fe77c23147b"
    sha256 cellar: :any,                 arm64_sonoma:  "3e68081749bde4dd1c92f809063005fd48f182a0ea1ee097c6910fe77c23147b"
    sha256 cellar: :any,                 sonoma:        "e95dd7eb19e55f4af7214c8906494b061283a43ba5a7ff2a9c56d700e2d31d03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d319668bd3c3c0d26e39da81438eff35c60f44a11940ff20a768f562fda933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d956f75b4fcd019c14c06ae495d998ed78e8db1edbd808a18096b71d9dcccece"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
