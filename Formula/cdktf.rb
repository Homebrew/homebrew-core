require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.9.4.tgz"
  sha256 "19d04aba527e143aba8449f06c9c7812f01feae70bf7f67a539ebe890831f4f7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "321d13d5450b6db88f43b4737f1f03aa4f1cff13566e66d27281d31a58ade256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "321d13d5450b6db88f43b4737f1f03aa4f1cff13566e66d27281d31a58ade256"
    sha256 cellar: :any_skip_relocation, monterey:       "c03b932276c398c7881d04a60fa9bb05129c2b3904bc7934d3948dadcae219b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c03b932276c398c7881d04a60fa9bb05129c2b3904bc7934d3948dadcae219b2"
    sha256 cellar: :any_skip_relocation, catalina:       "c03b932276c398c7881d04a60fa9bb05129c2b3904bc7934d3948dadcae219b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "321d13d5450b6db88f43b4737f1f03aa4f1cff13566e66d27281d31a58ade256"
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
