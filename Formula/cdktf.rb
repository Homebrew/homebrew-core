require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.0.17.tgz"
  sha256 "503d7ab540a30893fb386014db194822ffcd847d2d159bf8c8fe7752d541889e"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1137c985cd950432ce80b0e7b2477c145a683c7d70ce7be0080a49aa8c8299d0" => :catalina
    sha256 "4abaf139e7febc8f59e5300d7b88df395b0f08d0b6c67754c2d2d7c2b1e6464a" => :mojave
    sha256 "1bd41bbd22b239ae949a1aa409ef731a47c22b9e82a388e6c903de6eed327bc7" => :high_sierra
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
