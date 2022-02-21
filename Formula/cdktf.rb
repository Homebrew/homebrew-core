require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.9.2.tgz"
  sha256 "e06902f9975313f707655562a17191db3f5b488f91bdeb0b9a3e6f2782e47ab8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4e90d31daee1dffa0a08d2addd630dfc4157b94a58d6f19be1fd59a5399cce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4e90d31daee1dffa0a08d2addd630dfc4157b94a58d6f19be1fd59a5399cce"
    sha256 cellar: :any_skip_relocation, monterey:       "6776b988fdfc44d9cbe5a1871a1fdf8d8a272afbfdd6edc5d58b080945a9955e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6776b988fdfc44d9cbe5a1871a1fdf8d8a272afbfdd6edc5d58b080945a9955e"
    sha256 cellar: :any_skip_relocation, catalina:       "6776b988fdfc44d9cbe5a1871a1fdf8d8a272afbfdd6edc5d58b080945a9955e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4e90d31daee1dffa0a08d2addd630dfc4157b94a58d6f19be1fd59a5399cce"
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
