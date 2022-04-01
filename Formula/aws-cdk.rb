require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.19.0.tgz"
  sha256 "c0d34fb05854cd6b9b7da3dd07228804879cc64b7791ac46fdaf8ff57fcf43d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9665b8b51cbc3df867b516edcc6ee7c50bcf166496328c043c0ee8c47dbfeaac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9665b8b51cbc3df867b516edcc6ee7c50bcf166496328c043c0ee8c47dbfeaac"
    sha256 cellar: :any_skip_relocation, monterey:       "f6307d632dc8e44d4bcbc0996d12bff21a4f210f465a02016178d259bc3e3512"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6307d632dc8e44d4bcbc0996d12bff21a4f210f465a02016178d259bc3e3512"
    sha256 cellar: :any_skip_relocation, catalina:       "f6307d632dc8e44d4bcbc0996d12bff21a4f210f465a02016178d259bc3e3512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0eb14e5c70ab5e4e0e67eb76bcdf3306aa24d463ec8bb432607396411cbcba6"
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
