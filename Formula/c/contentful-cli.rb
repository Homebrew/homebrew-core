class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.12.tgz"
  sha256 "0d08e949d2b7b895609ca406d6ae04ec83f4af35b102c1e8e3828ac2fdcfd6f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47c2cca69ffed0a4b4ca27e8671e411b1f7df37eb856b51bedc00afddaaef02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee916dcc28ce5414e501f8b690f45d0526bf323b9d08496b749d294409ab6c77"
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
