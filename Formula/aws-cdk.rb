require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.46.0.tgz"
  sha256 "eb0af583a7056847ebbf26ff7e449da030023e52309f3fb63b9b517298d59e7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "62ce490dabd603a71a75c50662cac1fe5a12f1ce0bb434965e62c95ef5af6f86" => :catalina
    sha256 "e6149ecc29eea1baf41ce5077669aa9789a45f0b13a52099fa12807ba86e8a04" => :mojave
    sha256 "10fe32b7d7397a35b67151c4356bff55090e07b8315add1e5b71bd6d190e3095" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
