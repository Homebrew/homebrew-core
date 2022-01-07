require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.6.tgz"
  sha256 "f8f85f9a920831b835c3e02e7e168bd13f8661c1144343d292c7ffa1eb6f99e4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81b7cf82c654b11db93a3649af603a5d22b4e2f54ed71261982b522d678584a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c81b7cf82c654b11db93a3649af603a5d22b4e2f54ed71261982b522d678584a"
    sha256 cellar: :any_skip_relocation, monterey:       "ba766e867dbb19df89bd265d7fa421bc859cdd43e32d4b7316fe79b00e8939a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba766e867dbb19df89bd265d7fa421bc859cdd43e32d4b7316fe79b00e8939a7"
    sha256 cellar: :any_skip_relocation, catalina:       "ba766e867dbb19df89bd265d7fa421bc859cdd43e32d4b7316fe79b00e8939a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81b7cf82c654b11db93a3649af603a5d22b4e2f54ed71261982b522d678584a"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
