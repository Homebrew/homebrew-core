class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.5.3.tgz"
  sha256 "893aa859ade8be01881b881fdd0058e802b6221805f465dafbdad1d1f4364361"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9c1db917bcce316bceed6552aa5c8b07b95b57c3463175ac3954d6b51862aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9c1db917bcce316bceed6552aa5c8b07b95b57c3463175ac3954d6b51862aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e9c1db917bcce316bceed6552aa5c8b07b95b57c3463175ac3954d6b51862aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d7318db99767f29ba28bc92e02be6218d7779b08adffbca397396626382dd2c"
    sha256 cellar: :any_skip_relocation, ventura:       "8d7318db99767f29ba28bc92e02be6218d7779b08adffbca397396626382dd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9c1db917bcce316bceed6552aa5c8b07b95b57c3463175ac3954d6b51862aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
