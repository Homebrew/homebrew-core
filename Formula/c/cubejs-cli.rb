class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.82.tgz"
  sha256 "aaab51eac565af070e3af5839678f645e66d66f9b9583110a303ab4c75c70df1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e36aae850b3828ac25a2fd34038950bd409455a390226578eade79e5f480757b"
    sha256 cellar: :any,                 arm64_sequoia: "39638333a13eabe58a6c908c4c109f6946cc765e53ca09bf0a5608c2bbb7f962"
    sha256 cellar: :any,                 arm64_sonoma:  "39638333a13eabe58a6c908c4c109f6946cc765e53ca09bf0a5608c2bbb7f962"
    sha256 cellar: :any,                 sonoma:        "3f0fc8847bce88fd4f6446618a6e4e64ba3efe566ed57b9f3892be72fb109e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "005309e9e65883497595d22ab1dad749f404fa6fcd287685e980acf91fcb60c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e772ca716d3ae00d41c39d7356107f3c59e3736eac6afb5153289914f8a357"
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
