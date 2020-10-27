require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.22.2.tgz"
  sha256 "88e8a404aafa50dbfed288273b09d6e28afc7486d25820e427423e3cfee3d994"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b9bad843416d926d53956b83322ada87d67cdfb910e3efc6c2d9a21562d93bb7" => :catalina
    sha256 "6312f3955757984e3fe185fc4aff1046f63c921f1d6550a7db0a69bb9fc46a92" => :mojave
    sha256 "aed23366d0054a80d973955beaf757c328ea0688f05131eace86a1a8055412b3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
