class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.16.tgz"
  sha256 "afaf38b692a927d0b7567dde5d901cc2113207efd0aa189986fe8effdf8a638f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a58242d5c870521cb10613224747ae1ca458c2ff9dc7f62853b338eb41da858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a58242d5c870521cb10613224747ae1ca458c2ff9dc7f62853b338eb41da858"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a58242d5c870521cb10613224747ae1ca458c2ff9dc7f62853b338eb41da858"
    sha256 cellar: :any_skip_relocation, sonoma:        "b646f83c992538b1a5699d844794a2c3288632b643925659cf9a233512126459"
    sha256 cellar: :any_skip_relocation, ventura:       "b646f83c992538b1a5699d844794a2c3288632b643925659cf9a233512126459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a58242d5c870521cb10613224747ae1ca458c2ff9dc7f62853b338eb41da858"
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
