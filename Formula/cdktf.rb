require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.6.3.tgz"
  sha256 "ab9ee31999f7032e1a2c3dc7f31abf067aeaa733454791f375d56e915a9eee95"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09d8c77077859270bb4b4c72ae7763abd14adbfd8a6a5adf95a50f4868663867"
    sha256 cellar: :any_skip_relocation, big_sur:       "be7d5accc80826416ffd07962dda04a45c42fa2c0f1d86411c4f0ef2e9da452b"
    sha256 cellar: :any_skip_relocation, catalina:      "be7d5accc80826416ffd07962dda04a45c42fa2c0f1d86411c4f0ef2e9da452b"
    sha256 cellar: :any_skip_relocation, mojave:        "be7d5accc80826416ffd07962dda04a45c42fa2c0f1d86411c4f0ef2e9da452b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd504f4c163b63bbec5442870278bfebed3ce89fbaa765c7db7c24e52a29729"
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
