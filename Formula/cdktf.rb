require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.2.0.tgz"
  sha256 "6b9e712cad5e42c2efc39147711818a90b007edbb1fe6f7b11599cf3358f66a9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43d362f3f4ec3204473339a155205c850fe9dc2cbb66afbd7c2522f1446d1470"
    sha256 cellar: :any_skip_relocation, big_sur:       "18d2ddf5d1bb3c0de6b48409d2f9849644bd8a798c60c0e5744ec58f9b7f9dee"
    sha256 cellar: :any_skip_relocation, catalina:      "9d16fec441860eb3b56cf03eb99623aba9a9f5042de266ff68ad47bedc242579"
    sha256 cellar: :any_skip_relocation, mojave:        "7bd8950f8a832af223b38bf59f470a8a78445e5c58489f6884b82cd471ecbd0a"
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
