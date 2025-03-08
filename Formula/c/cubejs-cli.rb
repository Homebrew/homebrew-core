class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.19.tgz"
  sha256 "aedab39f31a4fc212f59f1630cc1b7db0428da246763dd18bc31612f51c8e2d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1becfee2958355b72e0f677dcb98d3d42b40abf9d51a29c53ac07b2535b7f60b"
    sha256 cellar: :any,                 arm64_sonoma:  "1becfee2958355b72e0f677dcb98d3d42b40abf9d51a29c53ac07b2535b7f60b"
    sha256 cellar: :any,                 arm64_ventura: "1becfee2958355b72e0f677dcb98d3d42b40abf9d51a29c53ac07b2535b7f60b"
    sha256 cellar: :any,                 sonoma:        "a4799d83ffce67474ec3ae8f21625b2916b3d5767d08934729225ca421fd7c29"
    sha256 cellar: :any,                 ventura:       "a4799d83ffce67474ec3ae8f21625b2916b3d5767d08934729225ca421fd7c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9ea1dafd2ad924114393b567fde036c30234d74b22383572c11fc06d03b372"
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
