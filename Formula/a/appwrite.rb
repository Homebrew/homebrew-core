require "language/node"

class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-5.0.3.tgz"
  sha256 "94ace9d8da0b45193aacddc2fcc8eeca1d34cd993ac49d539735cc7667422d5c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "302e181975b57ffd64f8ae5c77df8a54ec2e605a9cab2a182aeedfa757830c8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302e181975b57ffd64f8ae5c77df8a54ec2e605a9cab2a182aeedfa757830c8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "302e181975b57ffd64f8ae5c77df8a54ec2e605a9cab2a182aeedfa757830c8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c11c7dc0f75a11a52e22c5ba656728bb2e49c6d7b38b781f3cc7bf77385a5ab"
    sha256 cellar: :any_skip_relocation, ventura:        "0c11c7dc0f75a11a52e22c5ba656728bb2e49c6d7b38b781f3cc7bf77385a5ab"
    sha256 cellar: :any_skip_relocation, monterey:       "0c11c7dc0f75a11a52e22c5ba656728bb2e49c6d7b38b781f3cc7bf77385a5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302e181975b57ffd64f8ae5c77df8a54ec2e605a9cab2a182aeedfa757830c8e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
