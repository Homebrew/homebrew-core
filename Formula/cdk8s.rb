require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.16.0.tgz"
  sha256 "fb4a79c1b009d369d7f125404dc760eeab8af82163ecea64785c3ea0206104d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b20f13bce718647543db74ca2e3b106678f2f156f6025fef80347608e2d2b7a" => :catalina
    sha256 "5123ab8236acf0fbbc224c2c66a3d830eac6c76f601df89a952970bf9422a3ad" => :mojave
    sha256 "f7a93b23de2c421a3e0c06fa6d70514e4566ef217e78ed7208091c33d5790364" => :high_sierra
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
