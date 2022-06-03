require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.11.1.tgz"
  sha256 "94f45cac469835a04166624e23c67ce9874699137730b4ab1d61ef27fa4e8576"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd7473cbe72f754ee3c69dde4801dc62e9dee83d13f72d9a950433c03b3e1a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd7473cbe72f754ee3c69dde4801dc62e9dee83d13f72d9a950433c03b3e1a9"
    sha256 cellar: :any_skip_relocation, monterey:       "e03295dbd474a743b282f91be65c06c5e56d9f7e9440500a1ee36e6138235956"
    sha256 cellar: :any_skip_relocation, big_sur:        "e03295dbd474a743b282f91be65c06c5e56d9f7e9440500a1ee36e6138235956"
    sha256 cellar: :any_skip_relocation, catalina:       "e03295dbd474a743b282f91be65c06c5e56d9f7e9440500a1ee36e6138235956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd7473cbe72f754ee3c69dde4801dc62e9dee83d13f72d9a950433c03b3e1a9"
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
