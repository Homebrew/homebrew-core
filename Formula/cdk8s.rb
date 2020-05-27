require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.22.0.tgz"
  sha256 "da242d496ca0ac4b63a5d5cfdc43581b8f22bf39a96d0d2fb9b358cd95beb2e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "676f4612198eb8e8c685d50a1e3b2a982b559f40493d50723aca5d19ef4c7565" => :catalina
    sha256 "4ec0b1b73025b606dfbfa0bb23731d7132c2b02e68b58de534dda9059357fd29" => :mojave
    sha256 "85ca3bbb134dbc96e43c2de06305cddcf6b50e44d9b200f792c91abea635fdc7" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/cdk8s", "import", "k8s", "-l", "python"
    assert_predicate testpath/"imports/k8s", :exist?, "cdk8s import did not work"
  end
end
