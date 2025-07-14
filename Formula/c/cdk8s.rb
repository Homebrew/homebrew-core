class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.130.tgz"
  sha256 "f7f06f28bfb532c0e602a9710615c182d8a6fdd533f98a39e386a0e9acd4df1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd37ec7848a037162e16cfe64facedb95ad0623f5ce9eee8780503ef70119cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd37ec7848a037162e16cfe64facedb95ad0623f5ce9eee8780503ef70119cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bd37ec7848a037162e16cfe64facedb95ad0623f5ce9eee8780503ef70119cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "983bf04bd20c8d9ad1a738d71b7880ff39d85f78d146e53d6bd4e064c1571b7c"
    sha256 cellar: :any_skip_relocation, ventura:       "983bf04bd20c8d9ad1a738d71b7880ff39d85f78d146e53d6bd4e064c1571b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bd37ec7848a037162e16cfe64facedb95ad0623f5ce9eee8780503ef70119cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bd37ec7848a037162e16cfe64facedb95ad0623f5ce9eee8780503ef70119cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
