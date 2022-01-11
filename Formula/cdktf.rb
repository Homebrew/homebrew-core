require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.6.tgz"
  sha256 "f8f85f9a920831b835c3e02e7e168bd13f8661c1144343d292c7ffa1eb6f99e4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00dee80fcbb45e740511211da35178f7a3ce919cef2d4d830a772385ce09943b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00dee80fcbb45e740511211da35178f7a3ce919cef2d4d830a772385ce09943b"
    sha256 cellar: :any_skip_relocation, monterey:       "dfb0ddf5104e071566da0ddc9f291d0feb1fcdfc2ce79a37dd69ead3957ed1c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfb0ddf5104e071566da0ddc9f291d0feb1fcdfc2ce79a37dd69ead3957ed1c2"
    sha256 cellar: :any_skip_relocation, catalina:       "dfb0ddf5104e071566da0ddc9f291d0feb1fcdfc2ce79a37dd69ead3957ed1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00dee80fcbb45e740511211da35178f7a3ce919cef2d4d830a772385ce09943b"
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
