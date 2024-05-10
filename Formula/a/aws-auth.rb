require "language/node"

class AwsAuth < Formula
  desc "Allows you to programmatically authenticate into AWS accounts through IAM roles"
  homepage "https://github.com/iamarkadyt/aws-auth#readme"
  url "https://registry.npmjs.org/@iamarkadyt/aws-auth/-/aws-auth-2.2.4.tgz"
  sha256 "79fd9c77a389e275f6a8e8bc08e5245c9699779da5621abd929a475322698146"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a60b04e342a6f7740665def07e9a7851d7214d47e1da66641e4b6692c7b67067"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a60b04e342a6f7740665def07e9a7851d7214d47e1da66641e4b6692c7b67067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a60b04e342a6f7740665def07e9a7851d7214d47e1da66641e4b6692c7b67067"
    sha256 cellar: :any_skip_relocation, sonoma:         "c825913a0ac4b4292f691dad42ae1fd4a576cc687c9607082bd588b14734b51b"
    sha256 cellar: :any_skip_relocation, ventura:        "c825913a0ac4b4292f691dad42ae1fd4a576cc687c9607082bd588b14734b51b"
    sha256 cellar: :any_skip_relocation, monterey:       "c825913a0ac4b4292f691dad42ae1fd4a576cc687c9607082bd588b14734b51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60b04e342a6f7740665def07e9a7851d7214d47e1da66641e4b6692c7b67067"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = pipe_output("#{bin}/aws-auth login 2>&1", "fake123")
    assert_match "Enter new passphrase", output

    assert_match version.to_s, shell_output("#{bin}/aws-auth version")
  end
end
