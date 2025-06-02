class OrgFormation < Formula
  desc "Infrastructure as Code (IaC) tool for AWS Organizations"
  homepage "https://github.com/org-formation/org-formation-cli"
  url "https://registry.npmjs.org/aws-organization-formation/-/aws-organization-formation-1.0.16.tgz"
  sha256 "a3d4be909939bb85b033886bbf8913ffe20e0946ad62f19a0169e2cfc8811406"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6a65fc18513bc1b102e4e1fbfa2714b884d9fe4728d6708ad853dbd24541673"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/org-formation --version")

    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/org-formation init test-init 2>&1", 1)
    assert_match "The security token included in the request is invalid", output
  end
end
