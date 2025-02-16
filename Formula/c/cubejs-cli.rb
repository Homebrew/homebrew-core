class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.5.tgz"
  sha256 "267ec262703692751a55f5819edc32c39d9c39c278d2809332e9777479150ecd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78c23d9148487a2190fa9813140c60d0ab665dc59c4da2f22eb998abfb967313"
    sha256 cellar: :any,                 arm64_sonoma:  "78c23d9148487a2190fa9813140c60d0ab665dc59c4da2f22eb998abfb967313"
    sha256 cellar: :any,                 arm64_ventura: "78c23d9148487a2190fa9813140c60d0ab665dc59c4da2f22eb998abfb967313"
    sha256 cellar: :any,                 sonoma:        "586661089156129dcc5535ae50dbb8f0718eaddf85c7b3e66bf930410c2b825a"
    sha256 cellar: :any,                 ventura:       "586661089156129dcc5535ae50dbb8f0718eaddf85c7b3e66bf930410c2b825a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0166ddaa7b931f8b93670c8ea5a98ef6a68db2cf78947d4caf293f53bf891bd"
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
