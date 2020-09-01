require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.0.17.tgz"
  sha256 "503d7ab540a30893fb386014db194822ffcd847d2d159bf8c8fe7752d541889e"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5c7287cff8afdf54bdf4726611f5525c67a4b763f46f9bbc2a5865be7ccdf0c" => :catalina
    sha256 "dad70dab191cbf12a6e7bfd22b6e7b835675810131b98d10397279f863ae7ff7" => :mojave
    sha256 "f4542d9fc8ccd4731ff65a71a496be739f4102578c9a13b68925bd065ef6d070" => :high_sierra
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
