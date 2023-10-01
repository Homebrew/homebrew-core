require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.97.0.tgz"
  sha256 "e76d751b386a923e9d5e9009df8a07bbc515459cdaa81b4a3f88bfd0b77772cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f743c4c184e02f2d872860dd22b8450260c50d3a29d571537a7c0be33bb3f5aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f743c4c184e02f2d872860dd22b8450260c50d3a29d571537a7c0be33bb3f5aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f743c4c184e02f2d872860dd22b8450260c50d3a29d571537a7c0be33bb3f5aa"
    sha256 cellar: :any_skip_relocation, ventura:        "149a4ee9f423be352ab102ad275299cff9323a2ecc15772f119f1f2de07ab2c4"
    sha256 cellar: :any_skip_relocation, monterey:       "149a4ee9f423be352ab102ad275299cff9323a2ecc15772f119f1f2de07ab2c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "149a4ee9f423be352ab102ad275299cff9323a2ecc15772f119f1f2de07ab2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ce0840d1cb8a6378dffb8fee4569380a1b66344c5837f8112d344347a8def8"
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
