require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.25.0.tgz"
  sha256 "7f2352b1f9ccba7234c63dde443dea29cc4a0e2f28664b4bbbe4d3f5e71642fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "efaf53ffab538afe3de5e9adf1cea580395de2907fff98b8691b2e3e9bfc60bb" => :catalina
    sha256 "eb445573a9ee9d1b72603f88a69811719f563420791d5176b20d0e3a64413dfd" => :mojave
    sha256 "c801c3ba74d97db9b7bcb2b312cc6cb261f46ebacf2520bc317efea3afbc0c72" => :high_sierra
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
