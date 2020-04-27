require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.20.0.tgz"
  sha256 "c0aa8c9371fe99440331553a466b4e875e1c6850b2ee3580082e58dbbabfef01"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4a9d31fc1f09eb3b9636461e0077bb2dd6c2355c38639d674f8436140e4a1ca" => :catalina
    sha256 "8a55971ec0790a61c680580dfee8081b54209965e8a3662391e83a5abcdd3f64" => :mojave
    sha256 "ed79b7ac524c42eed6d49f1341d84ee972f0a8db59894852b52585abbdff44fe" => :high_sierra
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
