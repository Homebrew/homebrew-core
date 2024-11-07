class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.4.7.tgz"
  sha256 "e5c785c2ddc813c7bfbda70f7d600d0777fa4006dadf64d4d16f29ec5fb8e44d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203957398111cbd35341dc29c51d575444ceb80848b615cf3a9c7ccc6cebbb73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203957398111cbd35341dc29c51d575444ceb80848b615cf3a9c7ccc6cebbb73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "203957398111cbd35341dc29c51d575444ceb80848b615cf3a9c7ccc6cebbb73"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bd15c87256760764f1c46a4bd1a61b294140a13c7b2ae7f91c56b8724bca55"
    sha256 cellar: :any_skip_relocation, ventura:       "17bd15c87256760764f1c46a4bd1a61b294140a13c7b2ae7f91c56b8724bca55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203957398111cbd35341dc29c51d575444ceb80848b615cf3a9c7ccc6cebbb73"
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
