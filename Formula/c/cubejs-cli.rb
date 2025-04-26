class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.8.tgz"
  sha256 "6ebc9175a7712b335e1820ecf3303b5c2f118f194a59d3cb5af4792f0dc8fab3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9854131bb4e048de263d90e1cd7a02a8f73833f0e9f0d536ef176471c574db45"
    sha256 cellar: :any,                 arm64_sonoma:  "9854131bb4e048de263d90e1cd7a02a8f73833f0e9f0d536ef176471c574db45"
    sha256 cellar: :any,                 arm64_ventura: "9854131bb4e048de263d90e1cd7a02a8f73833f0e9f0d536ef176471c574db45"
    sha256 cellar: :any,                 sonoma:        "ae942ba3a3f990b69cc80e42d63675a03cf1f0489e7c0714f32a2b6a6a6276dd"
    sha256 cellar: :any,                 ventura:       "ae942ba3a3f990b69cc80e42d63675a03cf1f0489e7c0714f32a2b6a6a6276dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e3c8adba73bfec1fc254e3b9ac1d7cd3bc224552c541a09fb49ffae8837cc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbdb19a1a897e0a45ab82b6bf0bf2ceaee933ade93903e68fbe7f47897e198e1"
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
