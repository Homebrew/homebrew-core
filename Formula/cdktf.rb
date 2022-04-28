require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.10.3.tgz"
  sha256 "84da94ac403cc99076e12c2a921b32468b90b55a068d6b2766f365b3fe5bb5fd"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06de4182c5a2abf54291a3b01e230f2e712a0f7214f7e754008721905311307c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06de4182c5a2abf54291a3b01e230f2e712a0f7214f7e754008721905311307c"
    sha256 cellar: :any_skip_relocation, monterey:       "55afe11273adf67930dde401a8fba65e5174366835816da7845d9e7266165c0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "55afe11273adf67930dde401a8fba65e5174366835816da7845d9e7266165c0d"
    sha256 cellar: :any_skip_relocation, catalina:       "55afe11273adf67930dde401a8fba65e5174366835816da7845d9e7266165c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06de4182c5a2abf54291a3b01e230f2e712a0f7214f7e754008721905311307c"
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
