require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.30.tgz"
  sha256 "533cab32305021026a9ae96adff691338b63a459dbc8f841c66aa199f014bcde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71ac75ddc0fa6477097edcec329f702c3d7d562b111f15fe7a7d059e944ab94a"
    sha256 cellar: :any,                 arm64_ventura:  "82bb582a6537fd3915de1754e38f25ad862a2b4c6ded216dcfaccf47d3374c48"
    sha256 cellar: :any,                 arm64_monterey: "7aa4970db6ad0af08b1824ab8b3d04bd25acdae00f4b21ee9b921e1e9a4083b5"
    sha256 cellar: :any,                 sonoma:         "efea0cd4ca159779602df02b817c1b85da9ab28f2614366b209beed8eabda3a7"
    sha256 cellar: :any,                 ventura:        "3e73a2229c4d9eefa7a650157f6bfe938b79044f5ccd39b0b1927ee78a02571c"
    sha256 cellar: :any,                 monterey:       "2a15586bec042a226d3846a03259c089d5671931abe7ed1b02ab15b2a4a49bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3762928427e70c973f5944f4f4476395ea4042070af3a77fee62e6b2d0c81c90"
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
