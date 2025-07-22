class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.41.tgz"
  sha256 "e0340c22c943f28614be3ba361f7f6cd2c1b2b543bd8311a1c4fa453288af88c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4db2008662211eeef3a0aff554000294cdb7685cc319255f47187256f5808d03"
    sha256 cellar: :any,                 arm64_sonoma:  "4db2008662211eeef3a0aff554000294cdb7685cc319255f47187256f5808d03"
    sha256 cellar: :any,                 arm64_ventura: "4db2008662211eeef3a0aff554000294cdb7685cc319255f47187256f5808d03"
    sha256 cellar: :any,                 sonoma:        "f0dc960233fa658930899d88945dc0b3408ff7be15deb427ec664d34f944eae0"
    sha256 cellar: :any,                 ventura:       "f0dc960233fa658930899d88945dc0b3408ff7be15deb427ec664d34f944eae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87aa933674974e97b09abba60c2e3b6425976c2ebe728f63287fcb4bee4a4bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19536d16d14afbe602b6fb6703a92b27cd91143847f92c144fb9b1954005c5b4"
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
