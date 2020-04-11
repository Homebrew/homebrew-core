require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.18.0.tgz"
  sha256 "c874fb4cb54c3b7fbdfa6fdffc67cd71c9e2dfd316a45d65cc8690ab1d4bc643"

  bottle do
    cellar :any_skip_relocation
    sha256 "c333ced11c6b223508a81a15f15cb1e721be449ba87aa81a7e404c268653bb8e" => :catalina
    sha256 "405172e2b1915d3b26e8f23e9c21313202a629ede8a33914bab545f33ef8d8f6" => :mojave
    sha256 "ded6342607087efad56cd1aeafcc6b1fecc9ddc4ffe272d039dfa156155e4373" => :high_sierra
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
