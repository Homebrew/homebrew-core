class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1101.0.tgz"
  sha256 "bf40ef8f1122b40a3a058e1cb1113506a95b590aa9fcc5cd0da8958da562cf1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6107629b7038bc570a870530004acb0f62b7de3e466a2292029b26732cc9e7b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be0206426ba9445361111f5a5b192d5e54c99634d1e2b166f78272e124bab8ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0206426ba9445361111f5a5b192d5e54c99634d1e2b166f78272e124bab8ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ec81e26b5cb44991137186cd57e72b82483b9a40616e4f0147c69994008c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9aaa0e8cd6f8725a7ba15775109d3960f1f8f3a8e83ba600b86159480dd8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9aaa0e8cd6f8725a7ba15775109d3960f1f8f3a8e83ba600b86159480dd8ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/aws-cdk/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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
