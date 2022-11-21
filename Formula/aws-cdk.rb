require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.51.1.tgz"
  sha256 "84911bb3b3e5f33d82bd17c2c4c6ce8227243846467ab8d432e888353d70e489"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6083f0ebb4d002e822694c374b3c6c13de4af9092dc9822e3604640dc526046b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6083f0ebb4d002e822694c374b3c6c13de4af9092dc9822e3604640dc526046b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6083f0ebb4d002e822694c374b3c6c13de4af9092dc9822e3604640dc526046b"
    sha256 cellar: :any_skip_relocation, monterey:       "f4e2d4f6f0ab2b98e5a964a2595c4b5b8b3881d18957e22e7f68a445ee73700a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4e2d4f6f0ab2b98e5a964a2595c4b5b8b3881d18957e22e7f68a445ee73700a"
    sha256 cellar: :any_skip_relocation, catalina:       "f4e2d4f6f0ab2b98e5a964a2595c4b5b8b3881d18957e22e7f68a445ee73700a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14d110cd3f86e2f65cbf8a44079d012ca5b7d9265e285bb426cf89227bd66f6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
